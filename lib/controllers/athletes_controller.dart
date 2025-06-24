import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AthletesController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _athletes = [];
  Map<String, dynamic>? _currentAthlete;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  // Getters
  List<Map<String, dynamic>> get athletes => _athletes;
  Map<String, dynamic>? get currentAthlete => _currentAthlete;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all athletes (coach/leader only)
  Future<List<Map<String, dynamic>>?> getAthletes({
    String? search,
    String? status,
    int? page,
    int? limit,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final response = await _apiService.get('athletes', queryParams: queryParams);
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
        
        _athletes = items.cast<Map<String, dynamic>>();
        _log('✅ Retrieved ${_athletes.length} athletes');
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
      print('🏃 Athletes Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 