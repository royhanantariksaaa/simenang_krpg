import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'package:flutter/widgets.dart';

class AthletesController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _athletes = [];
  Map<String, dynamic>? _currentAthlete;
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
  List<Map<String, dynamic>> get athletes => _athletes;
  Map<String, dynamic>? get currentAthlete => _currentAthlete;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Pagination getters
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get perPage => _perPage;
  int get total => _total;
  bool get hasMorePages => _hasMorePages;

  // Get all athletes (coach/leader only) - now with pagination
  Future<List<Map<String, dynamic>>?> getAthletes({
    String? search,
    String? status,
    int? page,
    int? perPage,
    bool refresh = false,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (page != null) queryParams['page'] = page.toString();
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final response = await _apiService.get('athletes', queryParams: queryParams);
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
        
        // Handle refresh vs append
        if (refresh || page == 1) {
          _athletes = items.cast<Map<String, dynamic>>();
        } else {
          _athletes.addAll(items.cast<Map<String, dynamic>>());
        }
        
        _log('✅ Retrieved ${items.length} athletes (Page $_currentPage of $_lastPage, Total: $_total)');
        _safeNotifyListeners();
        return _athletes;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get athletes');
        return null;
      }
    } catch (e) {
      _setError('Get athletes error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Load next page of athletes
  Future<List<Map<String, dynamic>>?> loadNextPage({
    String? search,
    String? status,
  }) async {
    if (!_hasMorePages || _isLoading) return _athletes;
    
    return await getAthletes(
      search: search,
      status: status,
      page: _currentPage + 1,
      perPage: _perPage,
    );
  }

  // Refresh athletes list
  Future<List<Map<String, dynamic>>?> refreshAthletes({
    String? search,
    String? status,
  }) async {
    return await getAthletes(
      search: search,
      status: status,
      page: 1,
      perPage: _perPage,
      refresh: true,
    );
  }

  // Get athlete statistics (coach/leader only)
  Future<Map<String, dynamic>?> getAthleteStats() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('athletes/stats');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved athlete statistics');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get athlete statistics');
        return null;
      }
    } catch (e) {
      _setError('Get athlete stats error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get athlete details
  Future<Map<String, dynamic>?> getAthleteDetail(String athleteId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('athletes/$athleteId');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _currentAthlete = data;
        _log('✅ Retrieved athlete details for ID: $athleteId');
        _safeNotifyListeners();
        return _currentAthlete;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get athlete details');
        return null;
      }
    } catch (e) {
      _setError('Get athlete details error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get athlete training history
  Future<List<Map<String, dynamic>>?> getAthleteTrainingHistory(String athleteId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('athletes/$athleteId/training-history');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} training history records for athlete ID: $athleteId');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved training history data for athlete ID: $athleteId');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get athlete training history');
        return null;
      }
    } catch (e) {
      _setError('Get athlete training history error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get athlete competition history
  Future<List<Map<String, dynamic>>?> getAthleteCompetitionHistory(String athleteId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('athletes/$athleteId/competition-history');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} competition history records for athlete ID: $athleteId');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved competition history data for athlete ID: $athleteId');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get athlete competition history');
        return null;
      }
    } catch (e) {
      _setError('Get athlete competition history error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Upload athlete invoice
  Future<Map<String, dynamic>?> uploadAthleteInvoice({
    required String athleteId,
    required File invoiceFile,
    String? notes,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'athletes/$athleteId/invoice',
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
        _log('✅ Invoice uploaded for athlete ID: $athleteId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to upload athlete invoice');
        return null;
      }
    } catch (e) {
      _setError('Upload athlete invoice error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Upload competition certificate (coach/leader only)
  Future<Map<String, dynamic>?> uploadCompetitionCertificate({
    required File certificateFile,
    required String certificateType, // participation/achievement/winner
    String? notes,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'athletes/certificates',
        fields: {
          'certificate_type': certificateType,
          if (notes != null) 'notes': notes,
        },
        files: {
          'certificate': certificateFile,
        },
      );
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Competition certificate uploaded');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to upload competition certificate');
        return null;
      }
    } catch (e) {
      _setError('Upload competition certificate error: $e');
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
      print('🏃 Athletes Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 