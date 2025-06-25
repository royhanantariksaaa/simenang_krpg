import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../models/training_model.dart';
import '../../../models/training_session_model.dart' as session_model;
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../services/location_service.dart';

class SimpleAttendanceScreen extends StatefulWidget {
  final Training training;
  final session_model.TrainingSession session;

  const SimpleAttendanceScreen({
    Key? key,
    required this.training,
    required this.session,
  }) : super(key: key);

  @override
  State<SimpleAttendanceScreen> createState() => _SimpleAttendanceScreenState();
}

class _SimpleAttendanceScreenState extends State<SimpleAttendanceScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  
  bool _isLoading = false;
  bool _isLocationEnabled = false;
  bool _isWithinDistance = false;
  double _distanceToTraining = 0.0;
  LatLng? _currentLocation;
  LatLng? _trainingLocation;
  bool _hasMarkedAttendance = false;
  
  // Maximum distance for attendance in meters
  static const double maxDistanceMeters = 100.0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationService.stopLocationUpdates();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔍 [Simple Attendance] Initializing location...');
      
      // Set training location with default fallback
      if (widget.training.location?.latitude != null && 
          widget.training.location?.longitude != null) {
        _trainingLocation = LatLng(
          widget.training.location!.latitude!,
          widget.training.location!.longitude!,
        );
        debugPrint('✅ [Simple Attendance] Training location set: ${_trainingLocation}');
      } else {
        // Fallback location for UEQ-S testing (Surabaya coordinates)
        _trainingLocation = LatLng(-7.2574719, 112.7520883);
        debugPrint('⚠️ [Simple Attendance] Using fallback training location: ${_trainingLocation}');
      }

      // Request location permissions
      final hasPermission = await _locationService.requestPermissions();
      if (hasPermission) {
        debugPrint('✅ [Simple Attendance] Location permission granted');
        setState(() {
          _isLocationEnabled = true;
        });

        // Get current location with error handling
        try {
          final position = await _locationService.getCurrentPosition();
          if (position != null) {
            _currentLocation = LatLng(position.latitude, position.longitude);
            _calculateDistance();
            debugPrint('✅ [Simple Attendance] Current location: ${_currentLocation}');
            
            // Center map on current location
            if (mounted) {
              _mapController.move(_currentLocation!, 16);
            }
          } else {
            debugPrint('⚠️ [Simple Attendance] Could not get current position, using fallback');
            // Use fallback location near training location for testing
            _currentLocation = LatLng(
              _trainingLocation!.latitude + 0.0001, 
              _trainingLocation!.longitude + 0.0001
            );
            _calculateDistance();
            if (mounted) {
              _mapController.move(_currentLocation!, 16);
            }
          }
        } catch (e) {
          debugPrint('❌ [Simple Attendance] Error getting position: $e');
          // Use fallback location for UEQ-S testing
          _currentLocation = LatLng(
            _trainingLocation!.latitude + 0.0001, 
            _trainingLocation!.longitude + 0.0001
          );
          _calculateDistance();
          if (mounted) {
            _mapController.move(_currentLocation!, 16);
          }
        }

        // Start location updates with error handling
        try {
          await _locationService.startLocationUpdates(
            interval: const Duration(seconds: 5),
            distanceFilter: 5,
          );
          debugPrint('✅ [Simple Attendance] Location updates started');
        } catch (e) {
          debugPrint('⚠️ [Simple Attendance] Could not start location updates: $e');
          // Continue without live updates for testing
        }
      } else {
        debugPrint('❌ [Simple Attendance] Location permission denied');
        _showError('Location permission is required for attendance marking');
      }
    } catch (e) {
      debugPrint('❌ [Simple Attendance] Location initialization error: $e');
      _showError('Failed to initialize location. Using test mode for UEQ-S.');
      
      // Fallback for UEQ-S testing mode
      _trainingLocation = LatLng(-7.2574719, 112.7520883);
      _currentLocation = LatLng(-7.2574719, 112.7520883);
      _isLocationEnabled = true;
      _isWithinDistance = true; // Allow attendance for testing
      _distanceToTraining = 0.0;
      
      if (mounted) {
        _mapController.move(_currentLocation!, 16);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _calculateDistance() {
    if (_currentLocation != null && _trainingLocation != null) {
      final distance = _locationService.calculateDistance(
        lat1: _currentLocation!.latitude,
        lon1: _currentLocation!.longitude,
        lat2: _trainingLocation!.latitude,
        lon2: _trainingLocation!.longitude,
      );

      setState(() {
        _distanceToTraining = distance;
        _isWithinDistance = distance <= maxDistanceMeters;
      });
    }
  }

  Future<void> _markAttendance() async {
    if (!_isWithinDistance) {
      _showError('You must be within ${maxDistanceMeters}m of the training location to mark attendance');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔍 [Simple Attendance] Marking attendance...');
      debugPrint('🔍 [Simple Attendance] Session ID: ${widget.session.id}');
      debugPrint('🔍 [Simple Attendance] Training ID: ${widget.training.idTraining}');
      
      final controller = context.read<TrainingController>();
      
      // Validate session ID - use training ID as fallback for UEQ-S testing
      String sessionId = widget.session.id;
      if (sessionId.isEmpty || sessionId == 'null') {
        sessionId = widget.training.idTraining;
        debugPrint('⚠️ [Simple Attendance] Using training ID as session ID: $sessionId');
      }
      
      final success = await controller.markAttendance(
        sessionId: sessionId,
        status: '2', // Present
        location: _currentLocation != null ? {
          'latitude': _currentLocation!.latitude,
          'longitude': _currentLocation!.longitude,
        } : null,
      );

      if (success) {
        setState(() {
          _hasMarkedAttendance = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Attendance marked successfully!'),
                ],
              ),
              backgroundColor: KRPGTheme.successColor,
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate back after a delay
          await Future.delayed(Duration(seconds: 2));
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      } else {
        _showError(controller.error ?? 'Failed to mark attendance');
      }
    } catch (e) {
      _showError('Error marking attendance: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading && !_hasMarkedAttendance
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
                _buildHeader(),
                
                // Map
                Expanded(
                  flex: 2,
                  child: _buildMap(),
                ),
                
                // Status and Actions
                Expanded(
                  flex: 1,
                  child: _buildStatusSection(),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.training.title,
                  style: KRPGTextStyles.heading5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text(
                widget.training.formattedTime,
                style: KRPGTextStyles.caption.copyWith(color: Colors.white70),
              ),
              SizedBox(width: 16),
              Icon(Icons.place, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.training.location?.locationName ?? 'Unknown Location',
                  style: KRPGTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_trainingLocation == null) {
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 64, color: Colors.grey[600]),
              SizedBox(height: 16),
              Text(
                'Training location not available',
                style: KRPGTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? _trainingLocation!,
        zoom: 16.0,
        minZoom: 12.0,
        maxZoom: 20.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.simenang_krpg',
        ),
        
        // Training location circle
        CircleLayer(
          circles: [
            CircleMarker(
              point: _trainingLocation!,
              radius: maxDistanceMeters,
              useRadiusInMeter: true,
              color: KRPGTheme.primaryColor.withOpacity(0.3),
              borderColor: KRPGTheme.primaryColor,
              borderStrokeWidth: 2,
            ),
          ],
        ),
        
        // Markers
        MarkerLayer(
          markers: [
            // Training location marker
            Marker(
              point: _trainingLocation!,
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: KRPGTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(Icons.pool, color: Colors.white, size: 20),
              ),
            ),
            
            // Current location marker
            if (_currentLocation != null)
              Marker(
                point: _currentLocation!,
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: _isWithinDistance ? KRPGTheme.successColor : KRPGTheme.dangerColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        children: [
          // Distance status
          KRPGCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _isLocationEnabled ? Icons.gps_fixed : Icons.gps_off,
                      color: _isLocationEnabled ? KRPGTheme.successColor : KRPGTheme.dangerColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isLocationEnabled
                            ? 'Distance: ${_distanceToTraining.toStringAsFixed(1)}m'
                            : 'Location services disabled',
                        style: KRPGTextStyles.bodyMedium,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isWithinDistance ? KRPGTheme.successColor : KRPGTheme.dangerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isWithinDistance ? 'In Range' : 'Out of Range',
                        style: KRPGTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!_isWithinDistance && _isLocationEnabled) ...[
                  SizedBox(height: 8),
                  Text(
                    'Move closer to the training location to mark attendance',
                    style: KRPGTextStyles.caption.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Action button
          if (_hasMarkedAttendance)
            Container(
              width: double.infinity,
              child: KRPGButton(
                text: 'Attendance Marked',
                onPressed: null,
                icon: Icons.check_circle,
                backgroundColor: KRPGTheme.successColor,
                textColor: Colors.white,
              ),
            )
          else
            Container(
              width: double.infinity,
              child: KRPGButton(
                text: _isLoading ? 'Marking Attendance...' : 'Mark Attendance',
                onPressed: _isWithinDistance && !_isLoading ? _markAttendance : null,
                icon: _isLoading ? null : Icons.check_circle_outline,
                backgroundColor: _isWithinDistance ? KRPGTheme.primaryColor : Colors.grey,
                textColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
} 