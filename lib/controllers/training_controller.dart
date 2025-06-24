import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../models/training_model.dart';
import '../models/training_session_model.dart' as session_model;
import '../models/training_statistics_model.dart';
import '../models/attendance_model.dart';

class TrainingController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  
  List<Training> _trainings = [];
  List<session_model.TrainingSession> _sessions = [];
  List<TrainingStatistics> _statistics = [];
  Training? _currentTraining;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  // Location tracking
  bool _isLocationTracking = false;
  Map<String, Map<String, dynamic>> _athleteLocations = {};

  // Getters
  List<Training> get trainings => _trainings;
  List<session_model.TrainingSession> get sessions => _sessions;
  List<TrainingStatistics> get statistics => _statistics;
  Training? get currentTraining => _currentTraining;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLocationTracking => _isLocationTracking;
  Map<String, Map<String, dynamic>> get athleteLocations => _athleteLocations;

  // Get all trainings with filtering
  Future<List<Training>> getTrainings({
    String? search,
    String? status,
    String? phase,
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
      if (phase != null && phase.isNotEmpty) queryParams['phase'] = phase;
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final response = await _apiService.get('training', queryParams: queryParams);
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
        
        _trainings = items
            .map((json) => Training.fromJson(json))
            .toList();
        _log('✅ Retrieved ${_trainings.length} trainings');
        _safeNotifyListeners();
        return _trainings;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get trainings');
        return [];
      }
    } catch (e) {
      _setError('Get trainings error: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Get training details
  Future<Training?> getTrainingDetails(String trainingId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/$trainingId');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _currentTraining = Training.fromJson(data);
        _log('✅ Retrieved training details for ID: $trainingId');
        _safeNotifyListeners();
        return _currentTraining;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get training details');
        return null;
      }
    } catch (e) {
      _setError('Get training details error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Check if training can be started
  Future<Map<String, dynamic>?> canStartTraining(String trainingId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/$trainingId/can-start');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Training availability checked for ID: $trainingId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to check training availability');
        return null;
      }
    } catch (e) {
      _setError('Check training availability error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Start training session
  Future<Map<String, dynamic>?> startTraining(String trainingId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('training/$trainingId/start');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Training session started for ID: $trainingId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to start training');
        return null;
      }
    } catch (e) {
      _setError('Start training error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get athletes for training
  Future<List<Map<String, dynamic>>?> getTrainingAthletes(String trainingId) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/$trainingId/athletes');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _log('✅ Retrieved ${data.length} athletes for training ID: $trainingId');
          return data.cast<Map<String, dynamic>>();
        } else {
          _log('✅ Retrieved athletes data for training ID: $trainingId');
          return [data];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get training athletes');
        return null;
      }
    } catch (e) {
      _setError('Get training athletes error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Mark attendance with location support
  Future<bool> markAttendance({
    required String sessionId,
    String? profileId, // Optional for self-marking
    String status = '2', // Default to present
    String? note,
    Map<String, double>? location, // latitude, longitude
  }) async {
    if (_isDisposed) return false;
    
    _setLoading(true);
    _clearError();

    try {
      final body = <String, dynamic>{
        'status': status,
        if (profileId != null) 'profile_id': profileId,
        if (note != null) 'note': note,
      };

      // Add location data if provided
      if (location != null && location.containsKey('latitude') && location.containsKey('longitude')) {
        body['location'] = {
          'latitude': location['latitude'],
          'longitude': location['longitude'],
        };
      }

      final response = await _apiService.post('training/sessions/$sessionId/attendance', body: body);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        _log('✅ Attendance marked for session ID: $sessionId');
        return true;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to mark attendance');
        return false;
      }
    } catch (e) {
      _setError('Mark attendance error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // End attendance phase
  Future<bool> endAttendance(String sessionId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('training/sessions/$sessionId/end-attendance');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        _log('✅ Attendance phase ended for session ID: $sessionId');
        return true;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to end attendance phase');
        return false;
      }
    } catch (e) {
      _setError('End attendance error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Record training statistics with improved validation
  Future<bool> recordStatistics({
    required String sessionId,
    required String profileId,
    required String stroke,
    String? duration,
    int? distance,
    required String energySystem,
    String? note,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final body = <String, dynamic>{
        'profile_id': profileId,
        'stroke': stroke,
        'energy_system': energySystem,
        if (duration != null) 'duration': duration,
        if (distance != null) 'distance': distance,
        if (note != null) 'note': note,
      };

      final response = await _apiService.post('training/sessions/$sessionId/statistics', body: body);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        _log('✅ Statistics recorded for session ID: $sessionId');
        return true;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to record statistics');
        return false;
      }
    } catch (e) {
      _setError('Record statistics error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get training statistics
  Future<Map<String, dynamic>?> getStatistics(String sessionId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/sessions/$sessionId/statistics');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved statistics for session ID: $sessionId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get statistics');
        return null;
      }
    } catch (e) {
      _setError('Get statistics error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // End training session
  Future<bool> endSession(String sessionId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('training/sessions/$sessionId/end');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        _log('✅ Training session ended for session ID: $sessionId');
        return true;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to end training session');
        return false;
      }
    } catch (e) {
      _setError('End session error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get real-time updates
  Future<Map<String, dynamic>?> getRealtimeUpdates(String trainingId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/$trainingId/realtime-updates');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved real-time updates for training ID: $trainingId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get real-time updates');
        return null;
      }
    } catch (e) {
      _setError('Get real-time updates error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Broadcast update
  Future<bool> broadcastUpdate({
    required String trainingId,
    required String message,
    required String type,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('training/$trainingId/broadcast', body: {
        'message': message,
        'type': type,
      });
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        _log('✅ Update broadcasted for training ID: $trainingId');
        return true;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to broadcast update');
        return false;
      }
    } catch (e) {
      _setError('Broadcast update error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get training sessions for a specific training
  Future<List<session_model.TrainingSession>?> getTrainingSessions(String trainingId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/$trainingId/sessions');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _sessions = data
              .map((json) => session_model.TrainingSession.fromJson(json))
              .toList();
          _log('✅ Retrieved ${_sessions.length} sessions for training ID: $trainingId');
          _safeNotifyListeners();
          return _sessions;
        } else {
          _log('✅ Retrieved sessions data for training ID: $trainingId');
          return [];
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get training sessions');
        return null;
      }
    } catch (e) {
      _setError('Get training sessions error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get session attendance
  Future<Map<String, dynamic>?> getSessionAttendance(String sessionId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/sessions/$sessionId/attendance');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved attendance for session ID: $sessionId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get session attendance');
        return null;
      }
    } catch (e) {
      _setError('Get session attendance error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update athlete attendance (coach only)
  Future<bool> updateAthleteAttendance({
    required String attendanceId,
    required String status,
    String? note,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final body = <String, dynamic>{
        'status': status,
        if (note != null) 'note': note,
      };

      final response = await _apiService.put('training/attendance/$attendanceId', body: body);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        _log('✅ Attendance updated for ID: $attendanceId');
        return true;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to update attendance');
        return false;
      }
    } catch (e) {
      _setError('Update attendance error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ===== LOCATION TRACKING METHODS =====

  // Update athlete location
  Future<Map<String, dynamic>?> updateLocation({
    required String sessionId,
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    if (_isDisposed) return null;

    try {
      final body = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
      };

      final response = await _apiService.post('training/sessions/$sessionId/location', body: body);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Location updated for session ID: $sessionId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to update location');
        return null;
      }
    } catch (e) {
      _setError('Update location error: $e');
      return null;
    }
  }

  // Get session locations (coach only)
  Future<Map<String, dynamic>?> getSessionLocations(String sessionId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('training/sessions/$sessionId/locations');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Retrieved locations for session ID: $sessionId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get session locations');
        return null;
      }
    } catch (e) {
      _setError('Get session locations error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get distance to training location
  Future<Map<String, dynamic>?> getDistanceToTraining({
    required String sessionId,
    required double latitude,
    required double longitude,
  }) async {
    if (_isDisposed) return null;

    try {
      final queryParams = <String, String>{
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };

      final response = await _apiService.get('training/sessions/$sessionId/distance', queryParams: queryParams);
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Distance calculated for session ID: $sessionId');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to calculate distance');
        return null;
      }
    } catch (e) {
      _setError('Calculate distance error: $e');
      return null;
    }
  }

  // Start location tracking for a session
  Future<bool> startLocationTracking(String sessionId) async {
    if (_isLocationTracking) return true;

    try {
      final hasPermission = await _locationService.requestPermissions();
      if (!hasPermission) {
        _setError('Location permission denied');
        return false;
      }

      final success = await _locationService.startLocationUpdates(
        interval: const Duration(seconds: 10),
        distanceFilter: 10,
      );

      if (success) {
        _isLocationTracking = true;
        _log('✅ Location tracking started for session ID: $sessionId');
        _safeNotifyListeners();
        return true;
      } else {
        _setError('Failed to start location tracking');
        return false;
      }
    } catch (e) {
      _setError('Start location tracking error: $e');
      return false;
    }
  }

  // Stop location tracking
  void stopLocationTracking() {
    if (_isLocationTracking) {
      _locationService.stopLocationUpdates();
      _isLocationTracking = false;
      _athleteLocations.clear();
      _log('🛑 Location tracking stopped');
      _safeNotifyListeners();
    }
  }

  // Check if athlete can check in based on location
  Future<bool> canCheckInAtLocation({
    required String sessionId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final distanceData = await getDistanceToTraining(
        sessionId: sessionId,
        latitude: latitude,
        longitude: longitude,
      );

      if (distanceData != null && distanceData['can_check_in'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      _log('❌ Location check error: $e');
      return false;
    }
  }

  // ===== PRIVATE METHODS =====

  void _setLoading(bool loading) {
    if (!_isDisposed) {
      _isLoading = loading;
      _safeNotifyListeners();
    }
  }

  void _setError(String error) {
    if (!_isDisposed) {
      _error = error;
      _log('❌ Error: $error');
      _safeNotifyListeners();
    }
  }

  void _clearError() {
    if (!_isDisposed) {
      _error = null;
      _safeNotifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      print('🏊 TrainingController: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopLocationTracking();
    super.dispose();
  }
} 