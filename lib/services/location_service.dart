import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  Position? _currentPosition;
  bool _isListening = false;

  // Getters
  Position? get currentPosition => _currentPosition;
  bool get isListening => _isListening;

  /// Request location permissions
  Future<bool> requestPermissions() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      return true;
    } catch (e) {
      print('❌ Location Service: Permission error: $e');
      return false;
    }
  }

  /// Get current position once
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) return null;

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print('📍 Location Service: Current position: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}');
      return _currentPosition;
    } catch (e) {
      print('❌ Location Service: Get current position error: $e');
      return null;
    }
  }

  /// Start listening to location updates
  Future<bool> startLocationUpdates({
    Duration interval = const Duration(seconds: 10),
    int distanceFilter = 10, // meters
  }) async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) return false;

      if (_isListening) {
        stopLocationUpdates();
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilter,
          timeLimit: Duration(seconds: interval.inSeconds),
        ),
      ).listen(
        (Position position) {
          _currentPosition = position;
          print('📍 Location Service: Position update: ${position.latitude}, ${position.longitude}');
        },
        onError: (error) {
          print('❌ Location Service: Position stream error: $error');
        },
      );

      _isListening = true;
      print('✅ Location Service: Started location updates');
      return true;
    } catch (e) {
      print('❌ Location Service: Start location updates error: $e');
      return false;
    }
  }

  /// Stop listening to location updates
  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
    _isListening = false;
    print('🛑 Location Service: Stopped location updates');
  }

  /// Calculate distance between two points in meters
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Check if user is within specified distance from training location
  Future<bool> isWithinDistance({
    required double trainingLat,
    required double trainingLon,
    double maxDistanceMeters = 100.0,
  }) async {
    try {
      final position = await getCurrentPosition();
      if (position == null) return false;

      final distance = calculateDistance(
        lat1: position.latitude,
        lon1: position.longitude,
        lat2: trainingLat,
        lon2: trainingLon,
      );

      print('📍 Location Service: Distance to training: ${distance.toStringAsFixed(2)}m');
      return distance <= maxDistanceMeters;
    } catch (e) {
      print('❌ Location Service: Distance check error: $e');
      return false;
    }
  }

  /// Get address from coordinates
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}';
      }
      return null;
    } catch (e) {
      print('❌ Location Service: Get address error: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    stopLocationUpdates();
  }
} 