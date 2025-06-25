import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/dummy_data_service.dart';
import '../models/user_model.dart';
import '../config/app_config.dart';
import 'package:flutter/widgets.dart';

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final DummyDataService _dummyDataService = DummyDataService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  bool _isDisposed = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => AppConfig.isDummyDataForUEQSTest ? _currentUser != null : _currentUser != null && _apiService.isAuthenticated;
  bool get isInitialized => _isInitialized;

  // Initialize auth state (load stored token and validate)
  Future<void> initialize() async {
    if (_isInitialized || _isDisposed) return;
    
    _log('🔐 Initializing authentication...');

    try {
      // Check if we're in dummy data mode for UEQ-S testing
      if (AppConfig.isDummyDataForUEQSTest) {
        _log('🧪 UEQ-S Testing Mode: Using dummy authentication...');
        
        // Create dummy user based on configuration
        final dummyUserData = _dummyDataService.generateDummyUser();
        _currentUser = User(
          idAccount: dummyUserData['id'].toString(),
          username: dummyUserData['name'],
          email: dummyUserData['email'],
          role: UserRole.fromString(dummyUserData['role']),
          status: UserStatus.active,
          createdAt: DateTime.now(),
          profile: Profile(
            idProfile: '1',
            idAccount: dummyUserData['id'].toString(),
            name: dummyUserData['name'],
            phoneNumber: dummyUserData['phone'],
            profilePicture: dummyUserData['profileImageUrl'],
            joinDate: DateTime.parse(dummyUserData['joinDate']),
            status: ProfileStatus.active,
          ),
        );
        
        _log('✅ Dummy user authenticated: ${_currentUser!.username} as ${_currentUser!.role.value}');
      } else {
        // Normal API initialization
      await _apiService.initialize();
      
      // Check if we have a stored token
      final hasStoredToken = await _storageService.isLoggedIn();
      
      if (hasStoredToken) {
        _log('📱 Found stored token, validating with server...');
        
        // Validate the token with the server
        final isValid = await checkToken();
        if (!isValid) {
          _log('❌ Stored token is invalid, clearing...');
          await _clearAllData();
        } else {
          _log('✅ Stored token is valid');
        }
      } else {
        _log('📱 No stored token found');
        }
      }
    } catch (e) {
      _log('❌ Error during initialization: $e');
      if (!AppConfig.isDummyDataForUEQSTest) {
      await _clearAllData();
      }
    } finally {
      _isInitialized = true;
      // Use post-frame callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          _safeNotifyListeners();
        }
      });
    }
  }

  // Login - Fixed to match Laravel API
  Future<bool> login(String login, String password, {String? role}) async {
    if (_isDisposed) return false;
    
    _setLoading(true);
    _clearError();

    try {
      // Check if we're in dummy data mode for UEQ-S testing
      if (AppConfig.isDummyDataForUEQSTest) {
        _log('🧪 UEQ-S Testing Mode: Using dummy login...');
        
        // Simulate login delay for realistic UX
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Accept any login credentials in dummy mode
        final selectedRole = role ?? 'coach'; // Use provided role or default to coach
        final dummyUserData = _dummyDataService.generateDummyUser(role: selectedRole);
        _currentUser = User(
          idAccount: dummyUserData['id'].toString(),
          username: dummyUserData['name'],
          email: dummyUserData['email'],
          role: UserRole.fromString(dummyUserData['role']),
          status: UserStatus.active,
          createdAt: DateTime.now(),
          profile: Profile(
            idProfile: '1',
            idAccount: dummyUserData['id'].toString(),
            name: dummyUserData['name'],
            phoneNumber: dummyUserData['phone'],
            profilePicture: dummyUserData['profileImageUrl'],
            joinDate: DateTime.parse(dummyUserData['joinDate']),
            status: ProfileStatus.active,
          ),
        );
        
        _log('✅ Dummy login successful for user: ${_currentUser!.username} as ${_currentUser!.role.value}');
        _safeNotifyListeners();
        return true;
      } else {
        // Normal API login
      final response = await _apiService.post('login', body: {
        'login': login, // Laravel expects 'login' field (email or username)
        'password': password,
      });

      final parsedResponse = ApiService.parseLaravelResponse(response);
        
      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        final token = data['token'];
        final role = data['role'];
        
        if (token != null) {
          // Save token to storage and memory
          await _apiService.setAuthToken(token);
          
          // Create a basic user object from the response
          _currentUser = User(
            idAccount: '0', // Will be updated when we get profile details
            email: login,
            username: login,
            role: UserRole.fromString(role),
            status: UserStatus.active,
            createdAt: DateTime.now(),
          );
          
          _log('✅ Login successful for user: $_currentUser');
          _safeNotifyListeners();
          return true;
        } else {
          _setError('No token received from server');
          return false;
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Login failed');
        return false;
        }
      }
    } catch (e) {
      _setError('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register - Fixed to match Laravel API
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    if (_isDisposed) return false;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('register', body: {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      });

      if (response['success']) {
        final data = response['data'];
        
        // Laravel API returns: { status: true, message: "...", data: AccountResource }
        _log('✅ Registration successful');
        _safeNotifyListeners();
        return true;
      } else {
        _setError(response['error'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<bool> logout() async {
    if (_isDisposed) return false;
    
    _setLoading(true);
    _clearError();

    try {
      // Try to logout from server (but don't fail if it doesn't work)
      try {
        await _apiService.post('logout');
        _log('✅ Server logout successful');
      } catch (e) {
        _log('⚠️ Server logout failed, but continuing with local logout: $e');
      }

      // Always clear local data
      await _clearAllData();
      _log('✅ Logout completed');
      return true;
    } catch (e) {
      _setError('Logout error: $e');
      // Still clear local data even if there's an error
      await _clearAllData();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check token validity
  Future<bool> checkToken() async {
    if (_isDisposed) return false;
    
    _clearError();

    try {
      final response = await _apiService.get('check-token');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        
        // Laravel check-token returns simplified data: { role, token }
        if (data != null && data['role'] != null) {
          // Update current user with role from token validation
          if (_currentUser != null) {
            _currentUser = _currentUser!.copyWith(role: UserRole.fromString(data['role']));
          } else {
            // Create basic user if we don't have one
            _currentUser = User(
              idAccount: '0',
              email: 'user@example.com', // Will be updated with profile details
              username: 'user',
              role: UserRole.fromString(data['role']),
              status: UserStatus.active,
              createdAt: DateTime.now(),
            );
          }
          
          _log('✅ Token is valid for role: ${data['role']}');
          _safeNotifyListeners();
          return true;
        } else {
          _log('❌ Invalid response structure from check-token');
          return false;
        }
      } else {
        _log('❌ Token validation failed: ${parsedResponse['error']}');
        return false;
      }
    } catch (e) {
      _log('❌ Token check error: $e');
      return false;
    }
  }

  // Clear all authentication data
  Future<void> _clearAllData() async {
    _currentUser = null;
    await _apiService.clearAuthToken();
    await _storageService.clearAllAuthData();
    _safeNotifyListeners();
    _log('🧹 All authentication data cleared');
  }

  // Get profile details
  Future<Map<String, dynamic>?> getProfileDetails() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('profile');

      if (response['success']) {
        final data = response['data'];
        _log('✅ Profile details retrieved successfully');
        return data;
      } else {
        _setError(response['error'] ?? 'Failed to get profile details');
        return null;
      }
    } catch (e) {
      _setError('Get profile error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    DateTime? birthDate,
    String? gender,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone_number'] = phone;
      if (address != null) body['address'] = address;
      if (birthDate != null) body['birth_date'] = birthDate.toIso8601String().split('T')[0];
      if (gender != null) body['gender'] = gender;

      final response = await _apiService.put('profile', body: body);

      if (response['success']) {
        _log('✅ Profile updated successfully');
        return true;
      } else {
        _setError(response['error'] ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError('Update profile error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Upload profile picture
  Future<bool> uploadProfilePicture(File imageFile) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'profile/picture',
        files: {'profile_picture': imageFile},
      );

      if (response['success']) {
        _log('✅ Profile picture uploaded successfully');
        return true;
      } else {
        _setError(response['error'] ?? 'Failed to upload profile picture');
        return false;
      }
    } catch (e) {
      _setError('Upload profile picture error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.put('profile/password', body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      });

      if (response['success']) {
        _log('✅ Password changed successfully');
        return true;
      } else {
        _setError(response['error'] ?? 'Failed to change password');
        return false;
      }
    } catch (e) {
      _setError('Change password error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // WebSocket authentication
  Future<Map<String, dynamic>?> websocketAuth({
    required String channelName,
    required String socketId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('realtime/auth', body: {
        'channel_name': channelName,
        'socket_id': socketId,
      });

      if (response['success']) {
        _log('✅ WebSocket authentication successful');
        return response['data'];
      } else {
        _setError(response['error'] ?? 'WebSocket authentication failed');
        return null;
      }
    } catch (e) {
      _setError('WebSocket auth error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Test API connection
  Future<bool> testConnection() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.testConnection();
      
      if (response['success']) {
        _log('✅ API connection test successful');
        return true;
      } else {
        _setError(response['error'] ?? 'API connection test failed');
        return false;
      }
    } catch (e) {
      _setError('API connection test error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Health check
  Future<bool> healthCheck() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.healthCheck();
      
      if (response['success']) {
        _log('✅ Health check successful');
        return true;
      } else {
        _setError(response['error'] ?? 'Health check failed');
        return false;
      }
    } catch (e) {
      _setError('Health check error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _log('❌ Error: $error');
    _safeNotifyListeners();
  }

  void _clearError() {
    _error = null;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      // Use post frame callback to ensure we're not in the middle of a build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          notifyListeners();
        }
      });
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      print('🔐 Auth Controller: $message');
    }
  }

  // Clear all data (for testing)
  void clearData() {
    _currentUser = null;
    _error = null;
    _isLoading = false;
    _apiService.clearAuthToken();
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 