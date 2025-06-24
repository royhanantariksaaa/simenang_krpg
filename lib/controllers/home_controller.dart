import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class HomeController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _homeData;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  // Getters
  Map<String, dynamic>? get homeData => _homeData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get home dashboard data
  Future<Map<String, dynamic>?> getHomeData() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('home');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _homeData = data;
        _log('✅ Retrieved home dashboard data');
        _safeNotifyListeners();
        return _homeData;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get home data');
        return null;
      }
    } catch (e) {
      _setError('Get home data error: $e');
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
      print('🏠 Home Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 