import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'firebase_service.dart';
import '../models/government_subsidy.dart';

class GovernmentSubsidiesService {
  static final GovernmentSubsidiesService _instance =
      GovernmentSubsidiesService._internal();
  factory GovernmentSubsidiesService() => _instance;
  GovernmentSubsidiesService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  // Get available subsidies
  Stream<List<GovernmentSubsidy>> getSubsidies({
    String? state,
    String? category,
    bool activeOnly = true,
  }) {
    try {
      Query query = _firebaseService.subsidiesCollection;

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      if (state != null && state.isNotEmpty) {
        query = query.where('eligibleStates', arrayContains: state);
      }

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      return query
          .orderBy('lastUpdated', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return GovernmentSubsidy.fromFirestore(data);
        }).toList();
      });
    } catch (e) {
      _firebaseService.logError('Get subsidies error', error: e);
      return Stream.value([]);
    }
  }

  // Get subsidy by ID
  Future<GovernmentSubsidy?> getSubsidyById(String subsidyId) async {
    try {
      DocumentSnapshot doc =
          await _firebaseService.subsidiesCollection.doc(subsidyId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GovernmentSubsidy.fromFirestore(data);
      }
      return null;
    } catch (e) {
      _firebaseService.logError('Get subsidy by ID error', error: e);
      return null;
    }
  }

  // Apply for subsidy
  Future<String> applyForSubsidy({
    required String subsidyId,
    required Map<String, dynamic> applicationData,
  }) async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create application document
      Map<String, dynamic> application = {
        'id': '',
        'userId': userId,
        'subsidyId': subsidyId,
        'applicationData': applicationData,
        'status': 'pending',
        'submittedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'documents': [],
        'remarks': '',
      };

      DocumentReference docRef = await _firebaseService.firestore
          .collection('subsidy_applications')
          .add(application);

      // Update with document ID
      await docRef.update({'id': docRef.id});

      await _firebaseService
          .logEvent('subsidy_application_submitted', parameters: {
        'subsidy_id': subsidyId,
        'user_id': userId,
        'application_id': docRef.id,
      });

      return docRef.id;
    } catch (e) {
      _firebaseService.logError('Apply for subsidy error', error: e);
      rethrow;
    }
  }

  // Get user's applications
  Stream<List<Map<String, dynamic>>> getUserApplications() {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) return Stream.value([]);

      return _firebaseService.firestore
          .collection('subsidy_applications')
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      _firebaseService.logError('Get user applications error', error: e);
      return Stream.value([]);
    }
  }

  // Get application status
  Future<Map<String, dynamic>?> getApplicationStatus(
      String applicationId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.firestore
          .collection('subsidy_applications')
          .doc(applicationId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      _firebaseService.logError('Get application status error', error: e);
      return null;
    }
  }

  // Upload application documents
  Future<String> uploadApplicationDocument({
    required String applicationId,
    required String documentType,
    required String fileName,
    required dynamic fileData, // File or Uint8List
  }) async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Upload to Firebase Storage
      String storagePath =
          'subsidy_applications/$userId/$applicationId/$documentType/$fileName';

      TaskSnapshot uploadTask;
      if (fileData is File) {
        uploadTask =
            await _firebaseService.storage.ref(storagePath).putFile(fileData);
      } else {
        uploadTask =
            await _firebaseService.storage.ref(storagePath).putData(fileData);
      }

      String downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update application with document info
      await _firebaseService.firestore
          .collection('subsidy_applications')
          .doc(applicationId)
          .update({
        'documents': FieldValue.arrayUnion([
          {
            'type': documentType,
            'fileName': fileName,
            'url': downloadUrl,
            'uploadedAt': FieldValue.serverTimestamp(),
          }
        ]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firebaseService
          .logEvent('application_document_uploaded', parameters: {
        'application_id': applicationId,
        'document_type': documentType,
        'file_name': fileName,
      });

      return downloadUrl;
    } catch (e) {
      _firebaseService.logError('Upload application document error', error: e);
      rethrow;
    }
  }

  // Search subsidies
  Future<List<GovernmentSubsidy>> searchSubsidies(String searchTerm) async {
    try {
      String lowerSearch = searchTerm.toLowerCase();

      QuerySnapshot snapshot = await _firebaseService.subsidiesCollection
          .where('searchKeywords', arrayContains: lowerSearch)
          .where('isActive', isEqualTo: true)
          .limit(20)
          .get();

      List<GovernmentSubsidy> results = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GovernmentSubsidy.fromFirestore(data);
      }).toList();

      await _firebaseService.logEvent('subsidies_searched', parameters: {
        'search_term': searchTerm,
        'results_count': results.length,
      });

      return results;
    } catch (e) {
      _firebaseService.logError('Search subsidies error', error: e);
      return [];
    }
  }

  // Get subsidy categories
  Future<List<String>> getSubsidyCategories() async {
    try {
      QuerySnapshot snapshot = await _firebaseService.subsidiesCollection
          .where('isActive', isEqualTo: true)
          .get();

      Set<String> categories = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String category = data['category'] ?? '';
        if (category.isNotEmpty) {
          categories.add(category);
        }
      }

      List<String> sortedCategories = categories.toList()..sort();

      await _firebaseService
          .logEvent('subsidy_categories_fetched', parameters: {
        'count': sortedCategories.length,
      });

      return sortedCategories;
    } catch (e) {
      _firebaseService.logError('Get subsidy categories error', error: e);
      return [];
    }
  }

  // Get eligible states
  Future<List<String>> getEligibleStates() async {
    try {
      QuerySnapshot snapshot = await _firebaseService.subsidiesCollection
          .where('isActive', isEqualTo: true)
          .get();

      Set<String> states = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> eligibleStates = data['eligibleStates'] ?? [];
        states.addAll(eligibleStates.cast<String>());
      }

      List<String> sortedStates = states.toList()..sort();

      return sortedStates;
    } catch (e) {
      _firebaseService.logError('Get eligible states error', error: e);
      return [];
    }
  }

  // Check eligibility for subsidy
  Future<Map<String, dynamic>> checkEligibility({
    required String subsidyId,
    required Map<String, dynamic> userProfile,
  }) async {
    try {
      GovernmentSubsidy? subsidy = await getSubsidyById(subsidyId);
      if (subsidy == null) {
        return {
          'eligible': false,
          'reason': 'Subsidy not found',
          'missingCriteria': [],
        };
      }

      bool eligible = true;
      List<String> missingCriteria = [];
      String reason = '';

      // Check basic eligibility criteria
      for (String criterion in subsidy.eligibilityCriteria) {
        // For now, we'll do a simple string check
        // In a real implementation, you'd parse the criterion string to extract field, operator, and value
        if (!criterion.toLowerCase().contains('eligible') &&
            !criterion.toLowerCase().contains('farmer')) {
          eligible = false;
          missingCriteria.add(criterion);
        }
      }

      if (!eligible) {
        reason =
            'Does not meet eligibility criteria: ${missingCriteria.join(', ')}';
      }

      await _firebaseService.logEvent('eligibility_checked', parameters: {
        'subsidy_id': subsidyId,
        'eligible': eligible,
        'missing_criteria_count': missingCriteria.length,
      });

      return {
        'eligible': eligible,
        'reason': reason,
        'missingCriteria': missingCriteria,
        'subsidy': subsidy,
      };
    } catch (e) {
      _firebaseService.logError('Check eligibility error', error: e);
      return {
        'eligible': false,
        'reason': 'Error checking eligibility',
        'missingCriteria': [],
      };
    }
  }

  // Get application statistics
  Future<Map<String, dynamic>> getApplicationStats() async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) return {};

      QuerySnapshot snapshot = await _firebaseService.firestore
          .collection('subsidy_applications')
          .where('userId', isEqualTo: userId)
          .get();

      int total = snapshot.docs.length;
      int pending = 0;
      int approved = 0;
      int rejected = 0;

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'pending';

        switch (status) {
          case 'pending':
            pending++;
            break;
          case 'approved':
            approved++;
            break;
          case 'rejected':
            rejected++;
            break;
        }
      }

      return {
        'total': total,
        'pending': pending,
        'approved': approved,
        'rejected': rejected,
      };
    } catch (e) {
      _firebaseService.logError('Get application stats error', error: e);
      return {};
    }
  }

  // Bookmark/Save subsidy for later
  Future<void> bookmarkSubsidy(String subsidyId) async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firebaseService.firestore
          .collection('user_bookmarks')
          .doc(userId)
          .set({
        'subsidies': FieldValue.arrayUnion([subsidyId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firebaseService.logEvent('subsidy_bookmarked', parameters: {
        'subsidy_id': subsidyId,
      });
    } catch (e) {
      _firebaseService.logError('Bookmark subsidy error', error: e);
      rethrow;
    }
  }

  // Remove bookmark
  Future<void> removeBookmark(String subsidyId) async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firebaseService.firestore
          .collection('user_bookmarks')
          .doc(userId)
          .update({
        'subsidies': FieldValue.arrayRemove([subsidyId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firebaseService.logEvent('subsidy_bookmark_removed', parameters: {
        'subsidy_id': subsidyId,
      });
    } catch (e) {
      _firebaseService.logError('Remove bookmark error', error: e);
      rethrow;
    }
  }

  // Get bookmarked subsidies
  Stream<List<String>> getBookmarkedSubsidies() {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) return Stream.value([]);

      return _firebaseService.firestore
          .collection('user_bookmarks')
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return List<String>.from(data['subsidies'] ?? []);
        }
        return <String>[];
      });
    } catch (e) {
      _firebaseService.logError('Get bookmarked subsidies error', error: e);
      return Stream.value([]);
    }
  }
}
