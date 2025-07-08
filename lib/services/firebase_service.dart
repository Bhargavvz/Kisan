import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  late firebase_auth.FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;
  late FirebaseMessaging _messaging;
  late FirebaseAnalytics _analytics;
  late FirebaseCrashlytics _crashlytics;
  late FirebaseRemoteConfig _remoteConfig;
  late FirebasePerformance _performance;

  // Getters
  firebase_auth.FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;
  FirebaseAnalytics get analytics => _analytics;
  FirebaseCrashlytics get crashlytics => _crashlytics;
  FirebaseRemoteConfig get remoteConfig => _remoteConfig;
  FirebasePerformance get performance => _performance;

  // Initialize Firebase
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );

      // Initialize all services
      _auth = firebase_auth.FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _messaging = FirebaseMessaging.instance;
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _remoteConfig = FirebaseRemoteConfig.instance;
      _performance = FirebasePerformance.instance;

      // Configure services
      await _configureFirestore();
      await _configureMessaging();
      await _configureRemoteConfig();
      await _configureCrashlytics();

      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Firebase options for different platforms
  FirebaseOptions? _getFirebaseOptions() {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "your-web-api-key",
        authDomain: "project-kisan-app.firebaseapp.com",
        projectId: "project-kisan-app",
        storageBucket: "project-kisan-app.appspot.com",
        messagingSenderId: "123456789",
        appId: "1:123456789:web:abcdef123456",
        measurementId: "G-XXXXXXXXXX",
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: "your-android-api-key",
        appId: "1:123456789:android:abcdef123456",
        messagingSenderId: "123456789",
        projectId: "project-kisan-app",
        storageBucket: "project-kisan-app.appspot.com",
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const FirebaseOptions(
        apiKey: "your-ios-api-key",
        appId: "1:123456789:ios:abcdef123456",
        messagingSenderId: "123456789",
        projectId: "project-kisan-app",
        storageBucket: "project-kisan-app.appspot.com",
        iosClientId: "123456789-abcdef.apps.googleusercontent.com",
        iosBundleId: "com.example.projectkisan",
      );
    }
    return null;
  }

  // Configure Firestore
  Future<void> _configureFirestore() async {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Configure Firebase Messaging
  Future<void> _configureMessaging() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Configure Remote Config
  Future<void> _configureRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults({
      'app_maintenance': false,
      'force_update': false,
      'min_app_version': '1.0.0',
      'weather_api_key': '',
      'news_api_key': '',
    });

    await _remoteConfig.fetchAndActivate();
  }

  // Configure Crashlytics
  Future<void> _configureCrashlytics() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('Background message received: ${message.messageId}');
  }

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get cropPricesCollection =>
      _firestore.collection('crop_prices');
  CollectionReference get cropDiagnosisCollection =>
      _firestore.collection('crop_diagnosis');
  CollectionReference get subsidiesCollection =>
      _firestore.collection('subsidies');
  CollectionReference get weatherCollection => _firestore.collection('weather');
  CollectionReference get newsCollection => _firestore.collection('news');
  CollectionReference get farmingTipsCollection =>
      _firestore.collection('farming_tips');
  CollectionReference get feedbackCollection =>
      _firestore.collection('feedback');
  CollectionReference get analyticsCollection =>
      _firestore.collection('analytics');

  // Current user helper
  firebase_auth.User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  // Log analytics event
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  // Log custom error
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    _crashlytics.recordError(error ?? message, stackTrace, fatal: false);
  }

  // Get remote config value
  String getRemoteConfigString(String key) {
    return _remoteConfig.getString(key);
  }

  bool getRemoteConfigBool(String key) {
    return _remoteConfig.getBool(key);
  }

  double getRemoteConfigDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  int getRemoteConfigInt(String key) {
    return _remoteConfig.getInt(key);
  }
}
