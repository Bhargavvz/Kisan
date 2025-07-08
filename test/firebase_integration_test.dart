import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/services/firebase_service.dart';
import '../lib/services/auth_service.dart';
import '../lib/services/crop_diagnosis_service.dart';
import '../lib/services/market_prices_service.dart';
import '../lib/services/government_subsidies_service.dart';

/// This is a test harness for Firebase integration testing
/// It's designed to be run as a separate app for manual testing
/// or can be adapted for automated tests with proper test fixtures

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService().initialize();

  // Instantiate all services
  final authService = AuthService();
  final diagnosisService = CropDiagnosisService();
  final marketService = MarketPricesService();
  final subsidiesService = GovernmentSubsidiesService();

  // Run the test app
  runApp(MaterialApp(
    home: FirebaseTestHarness(
      authService: authService,
      diagnosisService: diagnosisService,
      marketService: marketService,
      subsidiesService: subsidiesService,
    ),
  ));
}

class FirebaseTestHarness extends StatefulWidget {
  final AuthService authService;
  final CropDiagnosisService diagnosisService;
  final MarketPricesService marketService;
  final GovernmentSubsidiesService subsidiesService;

  const FirebaseTestHarness({
    super.key,
    required this.authService,
    required this.diagnosisService,
    required this.marketService,
    required this.subsidiesService,
  });

  @override
  State<FirebaseTestHarness> createState() => _FirebaseTestHarnessState();
}

class _FirebaseTestHarnessState extends State<FirebaseTestHarness> {
  String _testResults = 'No tests run yet';
  bool _isRunningTests = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Integration Tests'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _isRunningTests ? null : _runAllTests,
              child: const Text('Run All Tests'),
            ),
            const SizedBox(height: 16),

            // Individual test buttons
            ElevatedButton(
              onPressed: _isRunningTests ? null : _testAuthentication,
              child: const Text('Test Authentication'),
            ),
            ElevatedButton(
              onPressed: _isRunningTests ? null : _testCropDiagnosis,
              child: const Text('Test Crop Diagnosis'),
            ),
            ElevatedButton(
              onPressed: _isRunningTests ? null : _testMarketPrices,
              child: const Text('Test Market Prices'),
            ),
            ElevatedButton(
              onPressed: _isRunningTests ? null : _testSubsidies,
              child: const Text('Test Subsidies'),
            ),

            const SizedBox(height: 24),
            const Text('Test Results:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: Text(_testResults),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunningTests = true;
      _testResults = 'Running all tests...\n';
    });

    try {
      await _testAuthentication();
      await _testCropDiagnosis();
      await _testMarketPrices();
      await _testSubsidies();

      setState(() {
        _testResults += '\nAll tests completed.';
      });
    } catch (e) {
      setState(() {
        _testResults += '\nTest run failed: $e';
      });
    } finally {
      setState(() {
        _isRunningTests = false;
      });
    }
  }

  Future<void> _testAuthentication() async {
    setState(() {
      _testResults += '\nTesting Authentication...';
    });

    try {
      // Test anonymous sign in
      final anonUser = await widget.authService.signInAnonymously();
      setState(() {
        _testResults +=
            '\n- Anonymous sign in: ${anonUser != null ? 'SUCCESS' : 'FAILED'}';
      });

      // Test auth state stream
      widget.authService.authStateChanges.listen((user) {
        setState(() {
          _testResults += '\n- Auth state changed: ${user?.uid ?? 'No user'}';
        });
      });

      // Test sign out
      await widget.authService.signOut();
      setState(() {
        _testResults += '\n- Sign out: SUCCESS';
      });
    } catch (e) {
      setState(() {
        _testResults += '\n- Authentication test failed: $e';
      });
    }
  }

  Future<void> _testCropDiagnosis() async {
    setState(() {
      _testResults += '\nTesting Crop Diagnosis...';
    });

    try {
      // Sign in anonymously to get user for tests
      await widget.authService.signInAnonymously();
      final userId = widget.authService.currentUser?.uid;

      if (userId == null) {
        setState(() {
          _testResults += '\n- Failed to get user for diagnosis tests';
        });
        return;
      }

      // Test getting diagnoses
      final diagnoses = await widget.diagnosisService.getUserDiagnoses(userId);
      setState(() {
        _testResults += '\n- Get diagnoses: ${diagnoses.length} found';
      });
    } catch (e) {
      setState(() {
        _testResults += '\n- Crop diagnosis test failed: $e';
      });
    }
  }

  Future<void> _testMarketPrices() async {
    setState(() {
      _testResults += '\nTesting Market Prices...';
    });

    try {
      // Test market price stream
      final streamSubscription = widget.marketService.getMarketPrices().listen(
        (prices) {
          setState(() {
            _testResults +=
                '\n- Market prices stream: ${prices.length} prices received';
          });
        },
        onError: (error) {
          setState(() {
            _testResults += '\n- Market prices stream error: $error';
          });
        },
      );

      // Cancel subscription after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      await streamSubscription.cancel();
    } catch (e) {
      setState(() {
        _testResults += '\n- Market prices test failed: $e';
      });
    }
  }

  Future<void> _testSubsidies() async {
    setState(() {
      _testResults += '\nTesting Subsidies...';
    });

    try {
      // Test subsidies stream
      final streamSubscription = widget.subsidiesService.getSubsidies().listen(
        (subsidies) {
          setState(() {
            _testResults +=
                '\n- Subsidies stream: ${subsidies.length} subsidies received';
          });
        },
        onError: (error) {
          setState(() {
            _testResults += '\n- Subsidies stream error: $error';
          });
        },
      );

      // Cancel subscription after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      await streamSubscription.cancel();
    } catch (e) {
      setState(() {
        _testResults += '\n- Subsidies test failed: $e';
      });
    }
  }
}
