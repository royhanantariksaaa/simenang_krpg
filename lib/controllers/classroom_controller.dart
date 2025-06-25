import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../services/api_service.dart';
import '../models/classroom_model.dart';

class ClassroomController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Classroom> _classrooms = [];
  Classroom? _currentClassroom;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;
  
  // Pagination metadata
  int _currentPage = 1;
  int _lastPage = 1;
  int _perPage = 15;
  int _total = 0;
  bool _hasMorePages = false;

  // Getters
  List<Classroom> get classrooms => _classrooms;
  Classroom? get currentClassroom => _currentClassroom;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Pagination getters
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get perPage => _perPage;
  int get total => _total;
  bool get hasMorePages => _hasMorePages;

  // Get all classrooms with filtering - now with pagination
  Future<List<Classroom>> getClassrooms({
    String? search,
    String? status,
    int? page,
    int? perPage,
    bool refresh = false,
  }) async {
    if (_isDisposed) return [];
    
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (page != null) queryParams['page'] = page.toString();
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final response = await _apiService.get('classrooms', queryParams: queryParams);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        
        // Handle Laravel pagination structure
        List<dynamic> items = [];
        Map<String, dynamic> paginationData = {};
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data')) {
            // Standard Laravel pagination
            items = data['data'] as List<dynamic>;
            paginationData = data;
          } else if (data.containsKey('items')) {
            // Custom pagination structure
          items = data['items'] as List<dynamic>;
            paginationData = data;
          } else {
            // Fallback to direct list
            items = data.values.toList();
          }
        } else if (data is List) {
          items = data;
        }
        
        // Update pagination metadata
        if (paginationData.isNotEmpty) {
          _currentPage = paginationData['current_page'] ?? 1;
          _lastPage = paginationData['last_page'] ?? 1;
          _perPage = paginationData['per_page'] ?? 15;
          _total = paginationData['total'] ?? items.length;
          _hasMorePages = _currentPage < _lastPage;
        }
        
        final newClassrooms = items
            .map((json) => Classroom.fromJson(json))
            .toList();
        
        // Handle refresh vs append
        if (refresh || page == 1) {
          _classrooms = newClassrooms;
        } else {
          _classrooms.addAll(newClassrooms);
        }
        
        _log('✅ Retrieved ${newClassrooms.length} classrooms (Page $_currentPage of $_lastPage, Total: $_total)');
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

  // Load next page of classrooms
  Future<List<Classroom>> loadNextPage({
    String? search,
    String? status,
  }) async {
    if (!_hasMorePages || _isLoading) return _classrooms;
    
    return await getClassrooms(
      search: search,
      status: status,
      page: _currentPage + 1,
      perPage: _perPage,
    );
  }

  // Refresh classrooms list
  Future<List<Classroom>> refreshClassrooms({
    String? search,
    String? status,
  }) async {
    return await getClassrooms(
      search: search,
      status: status,
      page: 1,
      perPage: _perPage,
      refresh: true,
    );
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

    // Debug: Log the classroom ID
    _log('🔍 Getting classroom details for ID: "$classroomId" (length: ${classroomId.length})');

    try {
      // Validate classroom ID
      if (classroomId.isEmpty) {
        _setError('Classroom ID cannot be empty');
        return null;
      }

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
      print('🏫 Classroom Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 