import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../services/api_service.dart';
import '../models/competition_model.dart';
import '../models/competition_result_model.dart' as result_model;
import '../models/competition_certificate_model.dart';

class CompetitionController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Competition> _competitions = [];
  List<result_model.CompetitionResult> _results = [];
  List<CompetitionCertificate> _certificates = [];
  Competition? _currentCompetition;
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
  List<Competition> get competitions => _competitions;
  List<result_model.CompetitionResult> get results => _results;
  List<CompetitionCertificate> get certificates => _certificates;
  Competition? get currentCompetition => _currentCompetition;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Pagination getters
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get perPage => _perPage;
  int get total => _total;
  bool get hasMorePages => _hasMorePages;

  // Get all competitions with filtering - now with pagination
  Future<List<Competition>> getCompetitions({
    String? search,
    String? status,
    String? level,
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
      if (level != null && level.isNotEmpty) queryParams['level'] = level;
      if (page != null) queryParams['page'] = page.toString();
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final response = await _apiService.get('competitions', queryParams: queryParams);
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
        
        final newCompetitions = items
            .map((json) => Competition.fromJson(json))
            .toList();
        
        // Handle refresh vs append
        if (refresh || page == 1) {
          _competitions = newCompetitions;
        } else {
          _competitions.addAll(newCompetitions);
        }
        
        _log('✅ Retrieved ${newCompetitions.length} competitions (Page $_currentPage of $_lastPage, Total: $_total)');
        _safeNotifyListeners();
        return _competitions;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get competitions');
        return [];
      }
    } catch (e) {
      _setError('Get competitions error: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Load next page of competitions
  Future<List<Competition>> loadNextPage({
    String? search,
    String? status,
    String? level,
  }) async {
    if (!_hasMorePages || _isLoading) return _competitions;
    
    return await getCompetitions(
      search: search,
      status: status,
      level: level,
      page: _currentPage + 1,
      perPage: _perPage,
    );
  }

  // Refresh competitions list
  Future<List<Competition>> refreshCompetitions({
    String? search,
    String? status,
    String? level,
  }) async {
    return await getCompetitions(
      search: search,
      status: status,
      level: level,
      page: 1,
      perPage: _perPage,
      refresh: true,
    );
  }

  // Get competition statistics
  Future<Map<String, dynamic>?> getCompetitionStats() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('competitions/stats');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved competition statistics');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get competition statistics');
        return null;
      }
    } catch (e) {
      _setError('Get competition stats error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get my competitions
  Future<List<Map<String, dynamic>>?> getMyCompetitions() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('competitions/my-competitions');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} my competitions');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved my competitions data');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get my competitions');
        return null;
      }
    } catch (e) {
      _setError('Get my competitions error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get competition details
  Future<Competition?> getCompetitionDetails(String competitionId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('competitions/$competitionId');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _currentCompetition = Competition.fromJson(data);
        _log('✅ Retrieved competition details for ID: $competitionId');
        _safeNotifyListeners();
        return _currentCompetition;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get competition details');
        return null;
      }
    } catch (e) {
      _setError('Get competition details error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Register for competition
  Future<Map<String, dynamic>?> registerForCompetition({
    required String competitionId,
    String? note,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('competitions/$competitionId/register', body: {
        if (note != null) 'note': note,
      });
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Registered for competition ID: $competitionId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to register for competition');
        return null;
      }
    } catch (e) {
      _setError('Register for competition error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get pending approvals (coach/leader only)
  Future<List<Map<String, dynamic>>?> getPendingApprovals() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('competitions/pending-approvals');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} pending approvals');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved pending approvals data');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get pending approvals');
        return null;
      }
    } catch (e) {
      _setError('Get pending approvals error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update delegation status (coach/leader only)
  Future<bool> updateDelegationStatus({
    required String registrationId,
    required String status, // approved/rejected
    String? note,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.put('competitions/registrations/$registrationId/status', body: {
        'status': status,
        if (note != null) 'note': note,
      });

      if (response['success']) {
        _log('✅ Delegation status updated for registration ID: $registrationId');
        return true;
      } else {
        _setError(response['error'] ?? 'Failed to update delegation status');
        return false;
      }
    } catch (e) {
      _setError('Update delegation status error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Upload certificate (coach/leader only)
  Future<Map<String, dynamic>?> uploadCertificate({
    required String registrationId,
    required File certificateFile,
    required String certificateType, // participation/achievement/winner
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'competitions/registrations/$registrationId/certificate',
        fields: {
          'certificate_type': certificateType,
          if (notes != null) 'notes': notes,
        },
        files: {
          'certificate': certificateFile,
        },
      );

      if (response['success']) {
        final data = response['data'];
        _log('✅ Certificate uploaded for registration ID: $registrationId');
        return data;
      } else {
        _setError(response['error'] ?? 'Failed to upload certificate');
        return null;
      }
    } catch (e) {
      _setError('Upload certificate error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Mark result as done (coach/leader only)
  Future<Map<String, dynamic>?> markResultDone({
    required String registrationId,
    int? position,
    String? timeResult,
    double? points,
    required String resultStatus, // DNS/DNF/DQ/completed
    required String resultType, // preliminary/final
    String? category,
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.put('competitions/registrations/$registrationId/result', body: {
        if (position != null) 'position': position,
        if (timeResult != null) 'time_result': timeResult,
        if (points != null) 'points': points,
        'result_status': resultStatus,
        'result_type': resultType,
        if (category != null) 'category': category,
        if (notes != null) 'notes': notes,
      });

      if (response['success']) {
        final data = response['data'];
        _log('✅ Result marked as done for registration ID: $registrationId');
        return data;
      } else {
        _setError(response['error'] ?? 'Failed to mark result as done');
        return null;
      }
    } catch (e) {
      _setError('Mark result done error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Withdraw from competition
  Future<bool> withdrawFromCompetition(String registrationId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('competitions/registrations/$registrationId/withdraw');

      if (response['success']) {
        _log('✅ Withdrawn from competition registration ID: $registrationId');
        return true;
      } else {
        _setError(response['error'] ?? 'Failed to withdraw from competition');
        return false;
      }
    } catch (e) {
      _setError('Withdraw from competition error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Approve registration (coach/leader only)
  Future<Map<String, dynamic>?> approveRegistration(String registrationId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('competitions/registrations/$registrationId/approve');

      if (response['success']) {
        final data = response['data'];
        _log('✅ Registration approved for ID: $registrationId');
        return data;
      } else {
        _setError(response['error'] ?? 'Failed to approve registration');
        return null;
      }
    } catch (e) {
      _setError('Approve registration error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Reject registration (coach/leader only)
  Future<Map<String, dynamic>?> rejectRegistration(String registrationId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('competitions/registrations/$registrationId/reject');

      if (response['success']) {
        final data = response['data'];
        _log('✅ Registration rejected for ID: $registrationId');
        return data;
      } else {
        _setError(response['error'] ?? 'Failed to reject registration');
        return null;
      }
    } catch (e) {
      _setError('Reject registration error: $e');
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
      print('🏆 Competition Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // Clear all data (for testing)
  void clearData() {
    _competitions.clear();
    _results.clear();
    _certificates.clear();
    _error = null;
    _isLoading = false;
    _safeNotifyListeners();
  }
} 