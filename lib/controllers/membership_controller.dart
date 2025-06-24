import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class MembershipController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _membershipStatus;
  List<Map<String, dynamic>> _paymentHistory = [];
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  // Getters
  Map<String, dynamic>? get membershipStatus => _membershipStatus;
  List<Map<String, dynamic>> get paymentHistory => _paymentHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get membership status
  Future<Map<String, dynamic>?> getMembershipStatus() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('membership/status');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _membershipStatus = data;
        _log('✅ Retrieved membership status');
        _safeNotifyListeners();
        return _membershipStatus;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get membership status');
        return null;
      }
    } catch (e) {
      _setError('Get membership status error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Upload payment evidence
  Future<Map<String, dynamic>?> uploadPaymentEvidence({
    required File paymentFile,
    String? notes,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'membership/payment-evidence',
        fields: {
          if (notes != null) 'notes': notes,
        },
        files: {
          'payment_evidence': paymentFile,
        },
      );
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Payment evidence uploaded successfully');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to upload payment evidence');
        return null;
      }
    } catch (e) {
      _setError('Upload payment evidence error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get payment history
  Future<List<Map<String, dynamic>>?> getPaymentHistory() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('membership/payment-history');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _paymentHistory = data.cast<Map<String, dynamic>>();
          _log('✅ Retrieved ${_paymentHistory.length} payment history records');
          _safeNotifyListeners();
          return _paymentHistory;
        } else {
          _paymentHistory = [data];
          _log('✅ Retrieved payment history data');
          _safeNotifyListeners();
          return _paymentHistory;
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get payment history');
        return null;
      }
    } catch (e) {
      _setError('Get payment history error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Alternative endpoint for membership status (from different route)
  Future<Map<String, dynamic>?> getMembershipStatusAlt() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('membership/status');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _membershipStatus = data;
        _log('✅ Retrieved membership status (alt endpoint)');
        _safeNotifyListeners();
        return _membershipStatus;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get membership status');
        return null;
      }
    } catch (e) {
      _setError('Get membership status error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Alternative endpoint for payment upload (from different route)
  Future<Map<String, dynamic>?> uploadPaymentEvidenceAlt({
    required File paymentFile,
    String? notes,
  }) async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.postMultipart(
        'membership/upload-payment',
        fields: {
          if (notes != null) 'notes': notes,
        },
        files: {
          'payment_evidence': paymentFile,
        },
      );
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        _log('✅ Payment evidence uploaded successfully (alt endpoint)');
        return data;
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to upload payment evidence');
        return null;
      }
    } catch (e) {
      _setError('Upload payment evidence error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Alternative endpoint for payment history (from different route)
  Future<List<Map<String, dynamic>>?> getPaymentHistoryAlt() async {
    if (_isDisposed) return null;
    
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('membership/payment-history');
      final parsedResponse = ApiService.parseLaravelResponse(response);

      if (parsedResponse['success']) {
        final data = parsedResponse['data'];
        if (data is List) {
          _paymentHistory = data.cast<Map<String, dynamic>>();
          _log('✅ Retrieved ${_paymentHistory.length} payment history records (alt endpoint)');
          _safeNotifyListeners();
          return _paymentHistory;
        } else {
          _paymentHistory = [data];
          _log('✅ Retrieved payment history data (alt endpoint)');
          _safeNotifyListeners();
          return _paymentHistory;
        }
      } else {
        _setError(parsedResponse['error'] ?? 'Failed to get payment history');
        return null;
      }
    } catch (e) {
      _setError('Get payment history error: $e');
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
      print('💳 Membership Controller: $message');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 