import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isFirstLaunch = true;
  bool _isOffline = false;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isOffline => _isOffline;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AppStateProvider() {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      
      if (_isLoggedIn) {
        await _loadUserData();
      }
    } catch (e) {
      _error = 'Failed to load app state: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('userData');
      if (userJson != null) {
        // In a real app, you'd parse the JSON here
        // For now, we'll create a mock user
        _currentUser = User(
          id: '1',
          name: prefs.getString('userName') ?? 'John Doe',
          email: prefs.getString('userEmail') ?? 'john@example.com',
          phoneNumber: prefs.getString('userPhone') ?? '+91 9876543210',
          address: prefs.getString('userAddress') ?? 'Bangalore, Karnataka',
          language: prefs.getString('userLanguage') ?? 'en',
        );
      }
    } catch (e) {
      _error = 'Failed to load user data: $e';
    }
  }

  Future<void> login(String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userPhone', phoneNumber);
      
      _isLoggedIn = true;
      _currentUser = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phoneNumber: phoneNumber,
        address: 'Bangalore, Karnataka',
        language: 'en',
      );
      
      await _saveUserData();
    } catch (e) {
      _error = 'Login failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userData');
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userPhone');
      await prefs.remove('userAddress');
      await prefs.remove('userLanguage');
      
      _isLoggedIn = false;
      _currentUser = null;
    } catch (e) {
      _error = 'Logout failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', false);
      _isFirstLaunch = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to complete onboarding: $e';
    }
  }

  Future<void> skipLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstLaunch', false);
      _isFirstLaunch = false;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to skip login: $e';
    }
  }

  Future<void> updateUser(User user) async {
    try {
      _currentUser = user;
      await _saveUserData();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update user: $e';
    }
  }

  Future<void> _saveUserData() async {
    if (_currentUser == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _currentUser!.name);
      await prefs.setString('userEmail', _currentUser!.email);
      await prefs.setString('userPhone', _currentUser!.phoneNumber);
      await prefs.setString('userAddress', _currentUser!.address);
      await prefs.setString('userLanguage', _currentUser!.language);
    } catch (e) {
      _error = 'Failed to save user data: $e';
    }
  }

  void setOfflineStatus(bool isOffline) {
    _isOffline = isOffline;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
