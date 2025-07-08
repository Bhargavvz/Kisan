import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'firebase_service.dart';
import '../models/crop_diagnosis.dart';

class CropDiagnosisService {
  static final CropDiagnosisService _instance =
      CropDiagnosisService._internal();
  factory CropDiagnosisService() => _instance;
  CropDiagnosisService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  // Submit crop diagnosis request
  Future<String> submitDiagnosis({
    required String cropType,
    required String description,
    required String location,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      String? imageUrl;

      // Upload image if provided
      if (imageFile != null || imageBytes != null) {
        imageUrl = await _uploadImage(
          imageFile: imageFile,
          imageBytes: imageBytes,
          imageName:
              imageName ?? 'diagnosis_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      // Create diagnosis document
      CropDiagnosis diagnosis = CropDiagnosis(
        id: '',
        userId: _firebaseService.currentUser?.uid ?? '',
        cropType: cropType,
        description: description,
        imageUrl: imageUrl ?? '',
        location: location,
        status: DiagnosisStatus.pending,
        submittedAt: DateTime.now(),
        diagnosisResult: null,
      );

      // Save to Firestore
      DocumentReference docRef = await _firebaseService.cropDiagnosisCollection
          .add(diagnosis.toFirestore());

      // Update with document ID
      await docRef.update({'id': docRef.id});

      await _firebaseService.logEvent('crop_diagnosis_submitted', parameters: {
        'crop_type': cropType,
        'has_image': imageUrl != null,
        'user_id': _firebaseService.currentUser?.uid ?? 'anonymous',
      });

      return docRef.id;
    } catch (e) {
      _firebaseService.logError('Submit diagnosis error', error: e);
      rethrow;
    }
  }

  /// Get user's diagnosis history
  Future<List<CropDiagnosis>> getUserDiagnoses(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firebaseService
          .cropDiagnosisCollection
          .where('userId', isEqualTo: userId)
          .orderBy('submittedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to data
        return CropDiagnosis.fromFirestore(data);
      }).toList();
    } catch (e) {
      print('Error getting user diagnoses: $e');
      throw Exception('Failed to get user diagnoses: $e');
    }
  }

  // Get diagnosis by ID
  Future<CropDiagnosis?> getDiagnosisById(String diagnosisId) async {
    try {
      DocumentSnapshot doc =
          await _firebaseService.cropDiagnosisCollection.doc(diagnosisId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CropDiagnosis.fromFirestore(data);
      }
      return null;
    } catch (e) {
      _firebaseService.logError('Get diagnosis by ID error', error: e);
      return null;
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage({
    File? imageFile,
    Uint8List? imageBytes,
    required String imageName,
  }) async {
    try {
      Reference storageRef = _firebaseService.storage
          .ref()
          .child('crop_diagnosis')
          .child('${_firebaseService.currentUser?.uid ?? 'anonymous'}')
          .child('$imageName.jpg');

      UploadTask uploadTask;
      if (imageFile != null) {
        uploadTask = storageRef.putFile(imageFile);
      } else if (imageBytes != null) {
        uploadTask = storageRef.putData(imageBytes);
      } else {
        throw Exception('No image provided');
      }

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firebaseService.logEvent('image_uploaded', parameters: {
        'category': 'crop_diagnosis',
        'file_size': imageBytes?.length ?? 0,
      });

      return downloadUrl;
    } catch (e) {
      _firebaseService.logError('Image upload error', error: e);
      rethrow;
    }
  }

  // Simulate AI diagnosis (in production, this would call an ML model)
  Future<DiagnosisResult> simulateAIDiagnosis(String diagnosisId) async {
    try {
      await Future.delayed(
          const Duration(seconds: 3)); // Simulate processing time

      // Mock diagnosis result
      DiagnosisResult result = DiagnosisResult(
        disease: 'Leaf Spot Disease',
        confidence: 0.85,
        description:
            'This appears to be a common leaf spot disease affecting your crop.',
        treatment: [
          'Remove affected leaves immediately',
          'Apply fungicide spray every 7-10 days',
          'Ensure proper drainage and air circulation',
          'Monitor regularly for spread',
        ],
        prevention: [
          'Avoid overhead watering',
          'Maintain proper plant spacing',
          'Apply preventive fungicide treatments',
          'Remove plant debris regularly',
        ],
        severity: DiseaseSeverity.moderate,
      );

      // Update diagnosis document
      await _firebaseService.cropDiagnosisCollection.doc(diagnosisId).update({
        'diagnosisResult': result.toJson(),
        'status': DiagnosisStatus.completed.name,
        'completedAt': FieldValue.serverTimestamp(),
      });

      await _firebaseService.logEvent('diagnosis_completed', parameters: {
        'diagnosis_id': diagnosisId,
        'disease': result.disease,
        'confidence': result.confidence,
        'severity': result.severity.name,
      });

      return result;
    } catch (e) {
      _firebaseService.logError('AI diagnosis error', error: e);

      // Update status to failed
      await _firebaseService.cropDiagnosisCollection.doc(diagnosisId).update({
        'status': DiagnosisStatus.failed.name,
      });

      rethrow;
    }
  }

  // Get diagnosis statistics
  Future<Map<String, dynamic>> getDiagnosisStats() async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) return {};

      QuerySnapshot snapshot = await _firebaseService.cropDiagnosisCollection
          .where('userId', isEqualTo: userId)
          .get();

      int total = snapshot.docs.length;
      int completed = snapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['status'] == DiagnosisStatus.completed.name;
      }).length;

      int pending = snapshot.docs.where((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['status'] == DiagnosisStatus.pending.name;
      }).length;

      Map<String, int> cropTypeCount = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String cropType = data['cropType'] ?? 'Unknown';
        cropTypeCount[cropType] = (cropTypeCount[cropType] ?? 0) + 1;
      }

      return {
        'total': total,
        'completed': completed,
        'pending': pending,
        'failed': total - completed - pending,
        'cropTypeBreakdown': cropTypeCount,
      };
    } catch (e) {
      _firebaseService.logError('Get diagnosis stats error', error: e);
      return {};
    }
  }

  // Delete diagnosis
  Future<void> deleteDiagnosis(String diagnosisId) async {
    try {
      await _firebaseService.cropDiagnosisCollection.doc(diagnosisId).delete();

      await _firebaseService.logEvent('diagnosis_deleted', parameters: {
        'diagnosis_id': diagnosisId,
      });
    } catch (e) {
      _firebaseService.logError('Delete diagnosis error', error: e);
      rethrow;
    }
  }
}
