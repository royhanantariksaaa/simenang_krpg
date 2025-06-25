import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../config/app_config.dart';
import 'offline_data_manager.dart';

class ApiService {
  // Base URL for Android emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Services
  final StorageService _storageService = StorageService();
  final OfflineDataManager _offlineDataManager = OfflineDataManager();

  // Auth token storage
  String? _authToken;
  bool _isInitialized = false;
  
  // Initialize the service (load stored token)
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final storedToken = await _storageService.getAuthToken();
      if (storedToken != null) {
        _authToken = storedToken;
        _log('Stored token loaded: ${storedToken.substring(0, 20)}...');
      } else {
        _log('No stored token found');
      }
    } catch (e) {
      _log('Error loading stored token: $e');
    } finally {
      _isInitialized = true;
    }
  }
  
  // Ensure service is initialized before making requests
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  // Headers for authenticated requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // Set auth token (both in memory and storage)
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    await _storageService.saveAuthToken(token);
    _log('Auth token set and saved: ${token.substring(0, 20)}...');
  }

  // Clear auth token (both from memory and storage)
  Future<void> clearAuthToken() async {
    _authToken = null;
    await _storageService.clearAuthToken();
    _log('Auth token cleared from memory and storage');
  }

  // Get current auth token
  String? get authToken => _authToken;

  // Check if user is authenticated
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;

  // GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    // Check if we're in dummy data mode for UEQ-S testing
    if (AppConfig.isDummyDataForUEQSTest) {
      _log('🧪 UEQ-S Testing Mode: Using offline data for GET $endpoint');
      return await _handleOfflineGet(endpoint, queryParams);
    }

    await _ensureInitialized();
    final uri = _buildUri(endpoint, queryParams);
    _log('GET Request: $uri');
    _log('Headers: $_headers');

    try {
      final response = await http.get(uri, headers: _headers);
      return _handleResponse(response, 'GET', endpoint);
    } catch (e) {
      return _handleError(e, 'GET', endpoint);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    // Check if we're in dummy data mode for UEQ-S testing
    if (AppConfig.isDummyDataForUEQSTest) {
      _log('🧪 UEQ-S Testing Mode: Using offline data for POST $endpoint');
      return await _handleOfflinePost(endpoint, body);
    }

    await _ensureInitialized();
    final uri = Uri.parse('$baseUrl/$endpoint');
    _log('POST Request: $uri');
    _log('Headers: $_headers');
    _log('Body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response, 'POST', endpoint);
    } catch (e) {
      return _handleError(e, 'POST', endpoint);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    await _ensureInitialized();
    final uri = Uri.parse('$baseUrl/$endpoint');
    _log('PUT Request: $uri');
    _log('Headers: $_headers');
    _log('Body: ${jsonEncode(body)}');

    try {
      final response = await http.put(
        uri,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response, 'PUT', endpoint);
    } catch (e) {
      return _handleError(e, 'PUT', endpoint);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    await _ensureInitialized();
    final uri = Uri.parse('$baseUrl/$endpoint');
    _log('DELETE Request: $uri');
    _log('Headers: $_headers');

    try {
      final response = await http.delete(uri, headers: _headers);
      return _handleResponse(response, 'DELETE', endpoint);
    } catch (e) {
      return _handleError(e, 'DELETE', endpoint);
    }
  }

  // Multipart POST for file uploads
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    await _ensureInitialized();
    final uri = Uri.parse('$baseUrl/$endpoint');
    _log('POST Multipart Request: $uri');
    _log('Headers: $_headers');
    _log('Fields: $fields');
    _log('Files: ${files?.keys.toList()}');

    try {
      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers.addAll(_headers);
      
      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }
      
      // Add files
      if (files != null) {
        for (final entry in files.entries) {
          final file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          );
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response, 'POST Multipart', endpoint);
    } catch (e) {
      return _handleError(e, 'POST Multipart', endpoint);
    }
  }

  // Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    final uri = Uri.parse('$baseUrl/$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response, String method, String endpoint) {
    _log('Response Status: ${response.statusCode}');
    _log('Response Headers: ${response.headers}');
    
    // Only log first 500 characters of response body to avoid overwhelming logs
    final bodyPreview = response.body.length > 500 
        ? '${response.body.substring(0, 500)}... (truncated)'
        : response.body;
    _log('Response Body: $bodyPreview');

    try {
      // Check if response body is empty
      if (response.body.isEmpty) {
        _log('❌ $method $endpoint: Empty response body');
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': 'Empty response from server',
        };
      }

      // Try to parse JSON with better error handling
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (jsonError) {
        _log('❌ $method $endpoint: JSON Parse Error - $jsonError');
        _log('Raw response body: ${response.body}');
        
        // Try to extract partial data if possible
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': 'Invalid JSON response: $jsonError',
          'rawBody': response.body,
          'jsonError': jsonError.toString(),
        };
      }
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _log('✅ $method $endpoint: Success');
        return {
          'success': true,
          'statusCode': response.statusCode,
          'data': data,
        };
      } else {
        _log('❌ $method $endpoint: HTTP Error ${response.statusCode}');
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': data['message'] ?? 'HTTP Error ${response.statusCode}',
          'data': data,
        };
      }
    } catch (e) {
      _log('❌ $method $endpoint: Unexpected Error - $e');
      return {
        'success': false,
        'statusCode': response.statusCode,
        'error': 'Unexpected error processing response',
        'exception': e.toString(),
        'rawBody': response.body,
      };
    }
  }

  // Helper method to parse Laravel API response
  static Map<String, dynamic> parseLaravelResponse(Map<String, dynamic> apiResponse) {
    if (!apiResponse['success']) {
      return {
        'success': false,
        'error': apiResponse['error'],
        'data': null,
        'rawResponse': apiResponse,
      };
    }

    final laravelResponse = apiResponse['data'];
    
    // Handle null or invalid data
    if (laravelResponse == null) {
      return {
        'success': false,
        'error': 'No data received from server',
        'data': null,
      };
    }
    
    // Check if it's a Laravel API response with status field
    if (laravelResponse is Map<String, dynamic> && laravelResponse.containsKey('status')) {
      if (laravelResponse['status'] == true) {
        return {
          'success': true,
          'data': laravelResponse['data'],
          'message': laravelResponse['message'],
        };
      } else {
        return {
          'success': false,
          'error': laravelResponse['message'] ?? 'Request failed',
          'data': laravelResponse['data'],
        };
      }
    }
    
    // If it's not a Laravel response, return as is
    return {
      'success': true,
      'data': laravelResponse,
    };
  }

  // Handle network/other errors
  Map<String, dynamic> _handleError(dynamic error, String method, String endpoint) {
    _log('❌ $method $endpoint: Network Error - $error');
    
    String errorMessage = 'Network error occurred';
    
    if (error is SocketException) {
      errorMessage = 'Unable to connect to server. Please check your internet connection.';
    } else if (error is HttpException) {
      errorMessage = 'HTTP error occurred';
    } else if (error is FormatException) {
      errorMessage = 'Invalid response format';
    }
    
    return {
      'success': false,
      'error': errorMessage,
      'exception': error.toString(),
    };
  }

  // Debug logging
  void _log(String message) {
    if (kDebugMode) {
      print('🔗 API Service: $message');
    }
  }

  // Test connection
  Future<Map<String, dynamic>> testConnection() async {
    _log('Testing API connection...');
    return await get('');
  }

  // Health check
  Future<Map<String, dynamic>> healthCheck() async {
    _log('Performing health check...');
    return await get('check-token');
  }

  // Handle offline GET requests for UEQ-S testing
  Future<Map<String, dynamic>> _handleOfflineGet(String endpoint, Map<String, String>? queryParams) async {
    try {
      // Map common endpoints to offline data manager methods
      switch (endpoint) {
        case 'athletes':
          final page = int.tryParse(queryParams?['page'] ?? '1') ?? 1;
          final limit = int.tryParse(queryParams?['limit'] ?? '20') ?? 20;
          final search = queryParams?['search'];
          return await _offlineDataManager.getAthletes(page: page, limit: limit, search: search);
          
        case 'training':
        case 'training-sessions':
          final page = int.tryParse(queryParams?['page'] ?? '1') ?? 1;
          final limit = int.tryParse(queryParams?['limit'] ?? '20') ?? 20;
          final status = queryParams?['status'];
          return await _offlineDataManager.getTrainingSessions(page: page, limit: limit, status: status);
          
        case 'classrooms':
          return await _offlineDataManager.getClassrooms();
          
        case 'competitions':
          final status = queryParams?['status'];
          return await _offlineDataManager.getCompetitions(status: status);
          
        case 'attendance':
          final athleteId = int.tryParse(queryParams?['athlete_id'] ?? '');
          final sessionId = int.tryParse(queryParams?['session_id'] ?? '');
          return await _offlineDataManager.getAttendance(athleteId: athleteId, sessionId: sessionId);
          
        case 'home':
        case 'dashboard/stats':
        case 'dashboard':
          return await _offlineDataManager.getDashboardStats();
          
        default:
          // Handle single resource requests and actions
          if (endpoint.contains('/')) {
            final parts = endpoint.split('/');
            
            if (parts.length >= 2) {
              final resource = parts[0];
              final id = int.tryParse(parts[1]);
              
              if (resource == 'athletes' && id != null) {
                return await _offlineDataManager.getAthlete(id);
              } else if (resource == 'training' && id != null) {
                if (parts.length == 2) {
                  // training/1 - get training details
                  return await _offlineDataManager.getTrainingDetails(id);
                } else if (parts.length == 3) {
                  final action = parts[2];
                  switch (action) {
                    case 'details':
                      return await _offlineDataManager.getTrainingDetails(id);
                    case 'can-start':
                      return await _offlineDataManager.canStartTraining(id);
                    case 'athletes':
                      return await _offlineDataManager.getTrainingAthletes(id);
                    case 'sessions':
                      return await _offlineDataManager.getTrainingSessions();
                    default:
                      return await _offlineDataManager.getTrainingDetails(id);
                  }
                }
              }
            }
          }
          
          // Default generic response
          return await _offlineDataManager.get(endpoint);
      }
         } catch (e) {
       _log('❌ Offline GET $endpoint error: $e');
       return <String, dynamic>{
         'success': false,
         'error': 'Offline mode error: $e',
       };
     }
  }

  // Handle offline POST requests for UEQ-S testing
  Future<Map<String, dynamic>> _handleOfflinePost(String endpoint, Map<String, dynamic>? body) async {
    try {
      // Map common POST endpoints
      switch (endpoint) {
        case 'training-sessions':
          return await _offlineDataManager.createTrainingSession(body ?? {});
          
        case 'attendance/checkin':
          return await _offlineDataManager.checkInOut(
            athleteId: body?['athlete_id'] ?? 1,
            sessionId: body?['session_id'] ?? 1,
            action: 'checkin',
            lat: body?['latitude'],
            lng: body?['longitude'],
          );
          
        case 'attendance/checkout':
          return await _offlineDataManager.checkInOut(
            athleteId: body?['athlete_id'] ?? 1,
            sessionId: body?['session_id'] ?? 1,
            action: 'checkout',
            lat: body?['latitude'],
            lng: body?['longitude'],
          );
          
        default:
          // Handle complex endpoints with multiple segments
          if (endpoint.contains('/')) {
            final parts = endpoint.split('/');
            
            if (parts.length >= 2) {
              final resource = parts[0];
              
              // Handle training sessions endpoints
              if (resource == 'training' && parts.length >= 4 && parts[1] == 'sessions') {
                final sessionId = parts[2];
                final action = parts[3];
                
                switch (action) {
                  case 'attendance':
                    _log('🧪 Handling attendance marking for session: $sessionId');
                    return await _offlineDataManager.markAttendance(
                      sessionId: sessionId,
                      profileId: body?['profile_id']?.toString(),
                      status: body?['status']?.toString() ?? '2',
                      note: body?['note']?.toString(),
                      location: body?['location'] != null 
                        ? Map<String, double>.from(body!['location'])
                        : null,
                    );
                  case 'statistics':
                    _log('🧪 Handling statistics recording for session: $sessionId');
                    return await _offlineDataManager.recordStatistics(
                      sessionId: sessionId,
                      profileId: body?['profile_id']?.toString() ?? 'current_user',
                      stroke: body?['stroke']?.toString() ?? 'freestyle',
                      duration: body?['duration']?.toString(),
                      distance: body?['distance'] is int ? body!['distance'] : int.tryParse(body?['distance']?.toString() ?? '0'),
                      energySystem: body?['energy_system']?.toString(),
                      note: body?['note']?.toString(),
                    );
                  case 'end-attendance':
                    return await _offlineDataManager.endAttendance(sessionId);
                  case 'end':
                    return await _offlineDataManager.endSession(sessionId);
                  default:
                    break;
                }
              }
              
              // Handle other endpoint patterns
              final id = int.tryParse(parts[1]);
              if (resource == 'training-sessions' && id != null) {
                return await _offlineDataManager.updateTrainingSession(id, body ?? {});
              } else if (resource == 'training' && id != null && parts.length == 3) {
                final action = parts[2];
                if (action == 'start') {
                  return await _offlineDataManager.startTraining(id);
                }
              }
            }
          }
          
          // Default generic response
          return await _offlineDataManager.post(endpoint, body: body);
      }
         } catch (e) {
       _log('❌ Offline POST $endpoint error: $e');
       return <String, dynamic>{
         'success': false,
         'error': 'Offline mode error: $e',
       };
     }
  }
} 