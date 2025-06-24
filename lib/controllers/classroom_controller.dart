import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/classroom_model.dart';

class ClassroomController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Classroom> _classrooms = [];
  Classroom? _currentClassroom;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  // Getters
  List<Classroom> get classrooms => _classrooms;
  Classroom? get currentClassroom => _currentClassroom;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all classrooms with filtering
  Future<List<Classroom>> getClassrooms({
    String? search,
    String? status,
    int? page,
    int? limit,
  }) async {
    if (_isDisposed) return [];
    
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final response = await _apiService.get('classrooms', queryParams: queryParams);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        
        // Handle Laravel pagination structure: data.items
        List<dynamic> items = [];
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          items = data['items'] as List<dynamic>;
        } else if (data is List) {
          items = data;
        } else {
          items = [];
        }
        
        _classrooms = items
            .map((json) => Classroom.fromJson(json))
            .toList();
        _log('✅ Retrieved ${_classrooms.length} classrooms');
        _safeNotifyListeners();
        return _classrooms;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get classrooms');
        return [];
      }
    } catch (e) {
      _setError('Get classrooms error: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Get classroom statistics
  Future<Map<String, dynamic>?> getClassroomStats() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('classrooms/stats');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved classroom statistics');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get classroom statistics');
        return null;
      }
    } catch (e) {
      _setError('Get classroom stats error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get my classrooms
  Future<List<Map<String, dynamic>>?> getMyClassrooms() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('classrooms/my-classrooms');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} my classrooms');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved my classrooms data');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get my classrooms');
        return null;
      }
    } catch (e) {
      _setError('Get my classrooms error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get classroom details
  Future<Classroom?> getClassroomDetails(String classroomId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('classrooms/$classroomId');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _currentClassroom = Classroom.fromJson(data);
        _log('✅ Retrieved classroom details for ID: $classroomId');
        _safeNotifyListeners();
        return _currentClassroom;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get classroom details');
        return null;
      }
    } catch (e) {
      _setError('Get classroom details error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get classroom students
  Future<List<Map<String, dynamic>>?> getClassroomStudents(String classroomId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('classrooms/$classroomId/students');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} students for classroom ID: $classroomId');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved students data for classroom ID: $classroomId');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get classroom students');
        return null;
      }
    } catch (e) {
      _setError('Get classroom students error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Upload invoice for student
  Future<Map<String, dynamic>?> uploadStudentInvoice({
    required String studentId,
    required File invoiceFile,
    String? notes,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'classrooms/students/$studentId/invoice',
        fields: {
          if (notes != null) 'notes': notes,
        },
        files: {
          'invoice': invoiceFile,
        },
      );
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Invoice uploaded for student ID: $studentId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to upload student invoice');
        return null;
      }
    } catch (e) {
      _setError('Upload student invoice error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Private methods
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
      // Add a small delay to ensure we're not in the middle of a build
      Future.microtask(() {
        if (!_isDisposed) {
          notifyListeners();
        }
      });
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      print('🏫 Classroom Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 