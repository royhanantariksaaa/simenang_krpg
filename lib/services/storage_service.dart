import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Save auth token
  Future<bool> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_tokenKey, token);
      _log('Token saved: ${success ? 'success' : 'failed'}');
      return success;
    } catch (e) {
      _log('Error saving token: $e');
      return false;
    }
  }

  // Get auth token
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      _log('Token retrieved: ${token != null ? 'found' : 'not found'}');
      return token;
    } catch (e) {
      _log('Error getting token: $e');
      return null;
    }
  }

  // Clear auth token
  Future<bool> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_tokenKey);
      _log('Token cleared: ${success ? 'success' : 'failed'}');
      return success;
    } catch (e) {
      _log('Error clearing token: $e');
      return false;
    }
  }

  // Save user data
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = userData.toString(); // Simple conversion for now
      final success = await prefs.setString(_userDataKey, userDataString);
      _log('User data saved: ${success ? 'success' : 'failed'}');
      return success;
    } catch (e) {
      _log('Error saving user data: $e');
      return false;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString != null) {
        // Simple parsing for now - in production, use proper JSON serialization
        _log('User data retrieved: found');
        return {'raw': userDataString}; // Placeholder
      }
      _log('User data retrieved: not found');
      return null;
    } catch (e) {
      _log('Error getting user data: $e');
      return null;
    }
  }

  // Clear user data
  Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_userDataKey);
      _log('User data cleared: ${success ? 'success' : 'failed'}');
      return success;
    } catch (e) {
      _log('Error clearing user data: $e');
      return false;
    }
  }

  // Clear all auth data
  Future<bool> clearAllAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenSuccess = await prefs.remove(_tokenKey);
      final userDataSuccess = await prefs.remove(_userDataKey);
      final success = tokenSuccess && userDataSuccess;
      _log('All auth data cleared: ${success ? 'success' : 'failed'}');
      return success;
    } catch (e) {
      _log('Error clearing all auth data: $e');
      return false;
    }
  }

  // Check if user is logged in (has stored token)
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Debug logging
  void _log(String message) {
    if (kDebugMode) {
      print('💾 Storage Service: $message');
    }
  }
} 