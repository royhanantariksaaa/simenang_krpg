import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class ApiService {
  // Base URL for Android emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Services
  final StorageService _storageService = StorageService();

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
} 