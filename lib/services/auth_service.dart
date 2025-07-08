import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';
import '../models/user.dart' as app_user;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  // Sign in with phone number
  Future<firebase_auth.UserCredential?> signInWithPhone(
      String phoneNumber) async {
    try {
      // For demo purposes, we'll use anonymous auth
      // In production, implement proper phone auth
      firebase_auth.UserCredential userCredential =
          await _firebaseService.auth.signInAnonymously();

      // Create user document in Firestore
      await _createUserDocument(userCredential.user!, phoneNumber: phoneNumber);

      await _firebaseService.logEvent('user_login', parameters: {
        'method': 'phone',
        'phone_number': phoneNumber,
      });

      return userCredential;
    } catch (e) {
      _firebaseService.logError('Phone sign in error', error: e);
      rethrow;
    }
  }

  // Phone verification (for production)
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(firebase_auth.PhoneAuthCredential) verificationCompleted,
    required Function(firebase_auth.FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _firebaseService.auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 60),
    );
  }

  // Sign in with credential
  Future<firebase_auth.UserCredential?> signInWithCredential(
      firebase_auth.AuthCredential credential) async {
    try {
      firebase_auth.UserCredential userCredential =
          await _firebaseService.auth.signInWithCredential(credential);
      await _createUserDocument(userCredential.user!);

      await _firebaseService.logEvent('user_login', parameters: {
        'method': 'phone_credential',
      });

      return userCredential;
    } catch (e) {
      _firebaseService.logError('Credential sign in error', error: e);
      rethrow;
    }
  }

  // Sign in anonymously (for guest users)
  Future<firebase_auth.UserCredential?> signInAnonymously() async {
    try {
      firebase_auth.UserCredential userCredential =
          await _firebaseService.auth.signInAnonymously();
      await _createUserDocument(userCredential.user!, isGuest: true);

      await _firebaseService.logEvent('user_login', parameters: {
        'method': 'anonymous',
      });

      return userCredential;
    } catch (e) {
      _firebaseService.logError('Anonymous sign in error', error: e);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseService.logEvent('user_logout');
      await _firebaseService.auth.signOut();
    } catch (e) {
      _firebaseService.logError('Sign out error', error: e);
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      firebase_auth.User? user = _firebaseService.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await _firebaseService.usersCollection.doc(user.uid).delete();

        // Delete user account
        await user.delete();

        await _firebaseService.logEvent('user_account_deleted');
      }
    } catch (e) {
      _firebaseService.logError('Delete account error', error: e);
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(
    firebase_auth.User user, {
    String? phoneNumber,
    bool isGuest = false,
  }) async {
    try {
      DocumentSnapshot userDoc =
          await _firebaseService.usersCollection.doc(user.uid).get();

      if (!userDoc.exists) {
        app_user.User newUser = app_user.User(
          id: user.uid,
          name: isGuest ? 'Guest User' : 'User',
          phoneNumber: phoneNumber ?? '',
          email: user.email ?? '',
          address: '',
          language: 'en',
          profileImageUrl: '',
          isGuest: isGuest,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          preferences: app_user.UserPreferences(
            language: 'en',
            theme: 'system',
            notifications: true,
            locationAccess: false,
          ),
        );

        await _firebaseService.usersCollection
            .doc(user.uid)
            .set(newUser.toFirestore());

        await _firebaseService.logEvent('user_created', parameters: {
          'user_id': user.uid,
          'is_guest': isGuest,
        });
      } else {
        // Update last login time
        await _firebaseService.usersCollection.doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      _firebaseService.logError('Create user document error', error: e);
      rethrow;
    }
  }

  // Get current user data
  Future<app_user.User?> getCurrentUserData() async {
    try {
      firebase_auth.User? currentUser = _firebaseService.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc =
            await _firebaseService.usersCollection.doc(currentUser.uid).get();
        if (userDoc.exists) {
          return app_user.User.fromFirestore(
              userDoc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      _firebaseService.logError('Get current user data error', error: e);
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(app_user.User user) async {
    try {
      firebase_auth.User? currentUser = _firebaseService.currentUser;
      if (currentUser != null) {
        await _firebaseService.usersCollection
            .doc(currentUser.uid)
            .update(user.toFirestore());

        await _firebaseService.logEvent('user_profile_updated', parameters: {
          'user_id': currentUser.uid,
        });
      }
    } catch (e) {
      _firebaseService.logError('Update user profile error', error: e);
      rethrow;
    }
  }

  // Stream of auth state changes
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseService.auth.authStateChanges();

  // Check if user is signed in
  bool get isSignedIn => _firebaseService.isSignedIn;

  // Get current user
  firebase_auth.User? get currentUser => _firebaseService.currentUser;
}
