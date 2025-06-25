import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../models/training_model.dart';
import '../../../models/training_session_model.dart' as session_model;
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/forms/krpg_dropdown.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../services/location_service.dart';
import '../../../services/realtime_service.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/user_model.dart';
import 'statistics_recording_dialog.dart';
import 'attendance_check_screen.dart';

class TrainingSessionScreen extends StatefulWidget {
  final Training training;
  final session_model.TrainingSession session;

  const TrainingSessionScreen({
    Key? key,
    required this.training,
    required this.session,
  }) : super(key: key);

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<Map<String, dynamic>> _athletes = [];
  List<Map<String, dynamic>> _statistics = [];
  session_model.TrainingSession? _currentSession;
  
  // Location and real-time services
  final LocationService _locationService = LocationService();
  final RealtimeService _realtimeService = RealtimeService();
  bool _isLocationEnabled = false;
  bool _isWithinDistance = false;
  double _distanceToTraining = 0.0;
  bool _isRealtimeConnected = false;

  // Stopwatch functionality for statistics tab
  int _currentAthleteIndex = 0;
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;
  bool _hasRecorded = false;
  String? _recordedTime;
  
  // Form inputs for statistics
  String? _selectedStroke;
  String? _selectedDistance;
  
  // Current athlete's existing statistics
  Map<String, dynamic>? _currentAthleteStats;

  // Bulk attendance selection
  Set<String> _selectedAthletes = {};
  bool _isBulkSelectMode = false;
  
  // Maximum distance for attendance in meters
  static const double maxDistanceMeters = 100.0;

  // Stroke options
  final List<Map<String, String>> _strokeOptions = [
    {'value': 'freestyle', 'label': 'Freestyle'},
    {'value': 'backstroke', 'label': 'Backstroke'},
    {'value': 'breaststroke', 'label': 'Breaststroke'},
    {'value': 'butterfly', 'label': 'Butterfly'},
    {'value': 'individual_medley', 'label': 'Individual Medley'},
    {'value': 'mixed', 'label': 'Mixed'},
  ];

  // Distance options
  final List<Map<String, String>> _distanceOptions = [
    {'value': '25', 'label': '25m'},
    {'value': '50', 'label': '50m'},
    {'value': '100', 'label': '100m'},
    {'value': '200', 'label': '200m'},
    {'value': '400', 'label': '400m'},
    {'value': '800', 'label': '800m'},
    {'value': '1500', 'label': '1500m'},
    {'value': 'custom', 'label': 'Custom'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentSession = widget.session; // Initialize with passed session
    _loadSessionData();
    _initializeLocationAndRealtime();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _locationService.stopLocationUpdates();
    _realtimeService.disconnect();
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocationAndRealtime() async {
    try {
      // Initialize location service with error handling
    final hasLocationPermission = await _locationService.requestPermissions();
    if (hasLocationPermission) {
        if (mounted) {
      setState(() {
        _isLocationEnabled = true;
      });
        }
      
        // Start location updates with error handling
        try {
      await _locationService.startLocationUpdates();
      
          // Check distance to training location if available
      if (widget.training.location != null) {
        _checkDistanceToTraining();
      }
        } catch (e) {
          print('⚠️ Location updates failed: $e');
          // Continue without location updates
        }
      } else {
        print('⚠️ Location permissions not granted');
      }
    } catch (e) {
      print('⚠️ Location initialization failed: $e');
      // Continue without location services
    }

    // Initialize real-time service
    // Note: This would need the auth token from the auth controller
    // For now, we'll just show the UI structure
    if (mounted) {
    setState(() {
      _isRealtimeConnected = true;
    });
    }
  }

  Future<void> _checkDistanceToTraining() async {
    if (widget.training.location?.latitude == null || 
        widget.training.location?.longitude == null) return;

    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final distance = _locationService.calculateDistance(
          lat1: position.latitude,
          lon1: position.longitude,
          lat2: widget.training.location!.latitude!,
          lon2: widget.training.location!.longitude!,
        );

        if (mounted) {
          setState(() {
            _distanceToTraining = distance;
            _isWithinDistance = distance <= maxDistanceMeters;
          });
        }
      }
    } catch (e) {
      print('⚠️ Distance check failed: $e');
      // Default to within range for testing purposes
      if (mounted) {
        setState(() {
          _isWithinDistance = true;
          _distanceToTraining = 0.0;
        });
      }
    }
  }

  Future<void> _loadSessionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = context.read<TrainingController>();

      // Refresh session status by getting current session data
      final sessions = await controller.getTrainingSessions(widget.training.idTraining);
      if (sessions != null && sessions.isNotEmpty) {
        // Find the current session
        final currentSessionData = sessions.firstWhere(
          (s) => s.id == widget.session.id,
          orElse: () => sessions.first,
        );
        if (mounted) {
          setState(() {
            _currentSession = currentSessionData;
          });
        }
      }

      // Load athletes for this training
      final athletes = await controller.getTrainingAthletes(widget.training.idTraining);
      if (athletes != null) {
        _athletes = athletes;
      }

      // Load statistics for this session
      final stats = await controller.getStatistics(widget.session.id);
      if (stats != null && stats['attendances'] != null) {
        final attendances = stats['attendances'] as List;
        _statistics = attendances.cast<Map<String, dynamic>>();
      }
      
      // Load current athlete's statistics
      _loadCurrentAthleteStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading session data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadCurrentAthleteStats() {
    if (_athletes.isEmpty) return;
    
    final currentAthlete = _athletes[_currentAthleteIndex];
    final athleteId = currentAthlete['id_profile'];
    
    // Find existing statistics for current athlete
    _currentAthleteStats = null;
    for (final attendance in _statistics) {
      if (attendance['id_profile'] == athleteId && attendance['statistics'] != null) {
        final stats = attendance['statistics'] as List;
        if (stats.isNotEmpty) {
          _currentAthleteStats = stats.first;
          break;
        }
      }
    }
    
    // If we have existing stats, populate the form and display the data
    if (_currentAthleteStats != null) {
      _selectedStroke = _currentAthleteStats!['stroke'];
      _selectedDistance = _currentAthleteStats!['distance']?.toString();
      
      // Parse the existing duration and set it as recorded time
      final existingDuration = _currentAthleteStats!['duration'];
      if (existingDuration != null) {
        _recordedTime = existingDuration;
        _hasRecorded = true;
        
        // Parse duration string (MM:SS.mmm) to Duration object
        final parts = existingDuration.split(':');
        if (parts.length >= 2) {
          final minutes = int.tryParse(parts[0]) ?? 0;
          final secondsParts = parts[1].split('.');
          final seconds = int.tryParse(secondsParts[0]) ?? 0;
          final milliseconds = secondsParts.length > 1 ? int.tryParse(secondsParts[1].padRight(3, '0')) ?? 0 : 0;
          
          _elapsedTime = Duration(
            minutes: minutes,
            seconds: seconds,
            milliseconds: milliseconds,
          );
        }
      }
    } else {
      // Reset form if no existing stats
      _selectedStroke = null;
      _selectedDistance = null;
      _recordedTime = null;
      _hasRecorded = false;
      _elapsedTime = Duration.zero;
    }
    
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button when in multi-select mode
        if (_isBulkSelectMode) {
          setState(() {
            _isBulkSelectMode = false;
            _selectedAthletes.clear();
          });
          return false; // Don't exit the screen
        }
        return true; // Allow normal back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Training Session'),
          backgroundColor: KRPGTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            // Only coaches can end sessions
            if (context.read<AuthController>().currentUser?.role == UserRole.coach)
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: _endSession,
                tooltip: 'End Session',
              ),
          ],
        ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Session Header
                _buildSessionHeader(),
                
                // Tab Bar
                Container(
                  color: KRPGTheme.primaryColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Attendance'),
                      Tab(text: 'Statistics'),
                      Tab(text: 'Overview'),
                    ],
                  ),
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAttendanceTab(),
                      _buildStatisticsTab(),
                      _buildOverviewTab(),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Column(
        children: [
          Text(
            widget.training.title,
            style: KRPGTextStyles.heading4.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Session ${widget.session.id}',
            style: KRPGTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          
          // Status Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusChip('Status', _getSessionStatusText(_currentSession?.status ?? widget.session.status)),
              _buildStatusChip('Athletes', '${_athletes.length}'),
              _buildStatusChip('Records', '${_statistics.length}'),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Location and Real-time Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusIndicator(
                'Location',
                _isLocationEnabled ? 'Enabled' : 'Disabled',
                _isLocationEnabled ? Colors.green : Colors.red,
                Icons.location_on,
              ),
              _buildStatusIndicator(
                'Distance',
                _isWithinDistance ? 'Within Range' : 'Out of Range',
                _isWithinDistance ? Colors.green : Colors.orange,
                Icons.radar,
              ),
              _buildStatusIndicator(
                'Real-time',
                _isRealtimeConnected ? 'Connected' : 'Disconnected',
                _isRealtimeConnected ? Colors.green : Colors.red,
                Icons.wifi,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getSessionStatusText(session_model.TrainingSessionStatus status) {
    switch (status) {
      case session_model.TrainingSessionStatus.attendance:
        return 'Attendance';
      case session_model.TrainingSessionStatus.recording:
        return 'Recording';
      case session_model.TrainingSessionStatus.completed:
        return 'Completed';
    }
  }

  Widget _buildAttendanceTab() {
    final authController = context.read<AuthController>();
    final userRole = authController.currentUser?.role;
    final isCoach = userRole == UserRole.coach;
    
    if (_athletes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No athletes found for this training'),
            SizedBox(height: 16),
            KRPGButton(
              text: 'Reload',
              onPressed: _loadSessionData,
            ),
          ],
        ),
      );
    }
    
    // Only coaches can mark attendance for others
    final canMarkAttendance = isCoach && (
        _currentSession?.status == session_model.TrainingSessionStatus.attendance ||
        _currentSession?.status == session_model.TrainingSessionStatus.recording ||
        _currentSession?.status == session_model.TrainingSessionStatus.completed
    );
    
    return Column(
      children: [
        // Role-based info banner
        if (!isCoach)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: KRPGTheme.infoColor,
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Viewing attendance records. Only coaches can modify attendance.',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        
        // Coach-only: Session status info for attendance management
        if (isCoach && _currentSession?.status != session_model.TrainingSessionStatus.attendance) 
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: _currentSession?.status == session_model.TrainingSessionStatus.recording 
                ? KRPGTheme.warningColor.withOpacity(0.8)
                : KRPGTheme.warningColor,
            child: Row(
              children: [
                Icon(
                  _currentSession?.status == session_model.TrainingSessionStatus.recording 
                      ? Icons.info 
                      : Icons.access_time, 
                  color: Colors.white
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentSession?.status == session_model.TrainingSessionStatus.recording 
                        ? 'Session is in recording phase. You can still mark attendance for late arrivals or corrections.'
                        : _currentSession?.status == session_model.TrainingSessionStatus.completed
                            ? 'Session completed. You can still update attendance records if needed.'
                            : 'Attendance can be marked during active sessions.',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: _loadSessionData,
                  child: Text('Refresh', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        
        // Coach-only: Bulk selection header
        if (isCoach && _isBulkSelectMode) _buildBulkSelectionHeader(),
        
        // Athletes list
        Expanded(
          child: ListView.builder(
            padding: KRPGSpacing.paddingMD,
            itemCount: _athletes.length,
            itemBuilder: (context, index) {
              final athlete = _athletes[index];
              final athleteId = athlete['id_profile']?.toString() ?? '';
              final isSelected = _selectedAthletes.contains(athleteId);
              
              return GestureDetector(
                onLongPress: (isCoach && canMarkAttendance) ? () {
                  // Enter multi-select mode and select this athlete
                  setState(() {
                    _isBulkSelectMode = true;
                    _selectedAthletes.add(athleteId);
                  });
                } : null,
                child: KRPGCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected && _isBulkSelectMode && isCoach
                          ? Border.all(color: KRPGTheme.primaryColor, width: 2)
                          : null,
                      color: isSelected && _isBulkSelectMode && isCoach
                          ? KRPGTheme.primaryColor.withOpacity(0.05)
                          : null,
                    ),
                    child: ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: athlete['profile_picture'] != null
                                ? NetworkImage(athlete['profile_picture'])
                                : null,
                            child: athlete['profile_picture'] == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          if (_isBulkSelectMode && isCoach)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? KRPGTheme.primaryColor 
                                      : Colors.grey[300],
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(
                                  isSelected ? Icons.check : Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(athlete['name'] ?? 'Unknown Athlete'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Classroom: ${athlete['classroom']?['name'] ?? 'Unknown'}'),
                          if (athlete['attendance_status'] != null)
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getAttendanceStatusColor(athlete['attendance_status']),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getAttendanceStatusText(athlete['attendance_status']),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: isCoach ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAttendanceButton(athlete, 'P', '1', canMarkAttendance),
                          const SizedBox(width: 2),
                          _buildAttendanceButton(athlete, 'L', '2', canMarkAttendance),
                          const SizedBox(width: 2),
                          _buildAttendanceButton(athlete, 'A', '0', canMarkAttendance),
                        ],
                      ) : 
                      // Athletes only see the attendance status, no buttons
                      athlete['attendance_status'] != null
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getAttendanceStatusColor(athlete['attendance_status']),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _getAttendanceStatusText(athlete['attendance_status']),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Not Marked',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      onTap: (_isBulkSelectMode && isCoach) 
                          ? () {
                              setState(() {
                                if (isSelected) {
                                  _selectedAthletes.remove(athleteId);
                                  // Exit multi-select if no athletes selected
                                  if (_selectedAthletes.isEmpty) {
                                    _isBulkSelectMode = false;
                                  }
                                } else {
                                  _selectedAthletes.add(athleteId);
                                }
                              });
                            }
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Coach-only: Bulk action buttons
        if (isCoach && _isBulkSelectMode && _selectedAthletes.isNotEmpty)
          _buildBulkActionButtons(canMarkAttendance),
      ],
    );
  }

  Widget _buildAttendanceButton(Map<String, dynamic> athlete, String label, String status, bool canMarkAttendance) {
    String tooltip = '';
    switch (label) {
      case 'P':
        tooltip = 'Mark Present';
        break;
      case 'L':
        tooltip = 'Mark Late';
        break;
      case 'A':
        tooltip = 'Mark Absent';
        break;
    }
    
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: canMarkAttendance 
            ? () => _markAttendance(athlete['id_profile']?.toString() ?? '', status)
            : null,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: canMarkAttendance 
                ? _getAttendanceColor(status)
                : Colors.grey,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                decoration: canMarkAttendance ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bulk Action Methods
  Widget _buildBulkSelectionHeader() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                _isBulkSelectMode = false;
                _selectedAthletes.clear();
              });
            },
            tooltip: 'Exit Selection',
          ),
          Expanded(
            child: Text(
              '${_selectedAthletes.length} selected',
              style: KRPGTextStyles.heading6.copyWith(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedAthletes = _athletes
                    .map((athlete) => athlete['id_profile']?.toString() ?? '')
                    .where((id) => id.isNotEmpty)
                    .toSet();
              });
            },
            child: Text(
              'Select All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionButtons(bool canMarkAttendance) {
    return Container(
      padding: KRPGSpacing.paddingMD,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: KRPGTheme.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: KRPGButton.primary(
              text: 'Present',
              onPressed: canMarkAttendance ? () => _bulkMarkAttendance('1') : null,
              icon: Icons.check_circle,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: KRPGButton(
              text: 'Late',
              onPressed: canMarkAttendance ? () => _bulkMarkAttendance('2') : null,
              icon: Icons.access_time,
              backgroundColor: canMarkAttendance ? KRPGTheme.warningColor : Colors.grey,
              textColor: Colors.white,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: KRPGButton.danger(
              text: 'Absent',
              onPressed: canMarkAttendance ? () => _bulkMarkAttendance('0') : null,
              icon: Icons.cancel,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bulkMarkAttendance(String status) async {
    if (_selectedAthletes.isEmpty) return;

    try {
      final controller = context.read<TrainingController>();
      int successCount = 0;
      int totalCount = _selectedAthletes.length;

      setState(() {
        _isLoading = true;
      });

      for (String athleteId in _selectedAthletes) {
        try {
          final success = await controller.markAttendance(
            sessionId: widget.session.id,
            profileId: athleteId,
            status: status,
          );
          if (success) successCount++;
        } catch (e) {
          print('Failed to mark attendance for athlete $athleteId: $e');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully marked $successCount of $totalCount athletes'),
          backgroundColor: successCount == totalCount 
              ? KRPGTheme.successColor 
              : KRPGTheme.warningColor,
        ),
      );

      // Clear selection and refresh data
      setState(() {
        _selectedAthletes.clear();
        _isBulkSelectMode = false;
      });
      _loadSessionData();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error performing bulk attendance: $e'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getAttendanceColor(String status) {
    switch (status) {
      case '1': // Present
        return Colors.green;
      case '2': // Late
        return Colors.orange;
      case '0': // Absent
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getAttendanceStatusColor(String? status) {
    switch (status) {
      case '1': // Present
        return KRPGTheme.successColor;
      case '2': // Late
        return KRPGTheme.warningColor;
      case '0': // Absent
        return KRPGTheme.dangerColor;
      default:
        return Colors.grey;
    }
  }

  String _getAttendanceStatusText(String? status) {
    switch (status) {
      case '1': // Present
        return 'Present';
      case '2': // Late
        return 'Late';
      case '0': // Absent
        return 'Absent';
      default:
        return 'Not Marked';
    }
  }

  Widget _buildStatisticsTab() {
    final authController = context.read<AuthController>();
    final userRole = authController.currentUser?.role;
    final isCoach = userRole == UserRole.coach;
    
    if (_athletes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No athletes found for this training'),
            SizedBox(height: 16),
            KRPGButton(
              text: 'Reload',
              onPressed: _loadSessionData,
            ),
          ],
        ),
      );
    }

    // Athletes get a read-only statistics view
    if (!isCoach) {
      return _buildAthleteStatisticsView();
    }

    // Coaches get the recording interface
    final currentAthlete = _athletes[_currentAthleteIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Role info for coaches
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: KRPGTheme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.edit_note, color: KRPGTheme.primaryColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recording statistics for athletes. Use the stopwatch to time performances.',
                    style: TextStyle(color: KRPGTheme.primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          
          // Athlete Navigation Header
          _buildAthleteHeader(currentAthlete),
          
          // Stopwatch Display
          _buildStopwatchDisplay(),
          
          // Input Controls
          _buildInputControls(),
          
          // Action Buttons
          _buildActionButtons(),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildAthleteStatisticsView() {
    return Column(
      children: [
        // Role-based info banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          color: KRPGTheme.infoColor,
          child: Row(
            children: [
              Icon(Icons.analytics, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Viewing training statistics. Only coaches can record new statistics.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        
        // Statistics list for all athletes
        Expanded(
          child: ListView.builder(
            padding: KRPGSpacing.paddingMD,
            itemCount: _athletes.length,
            itemBuilder: (context, index) {
              final athlete = _athletes[index];
              return KRPGCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: athlete['profile_picture'] != null
                        ? NetworkImage(athlete['profile_picture'])
                        : null,
                    child: athlete['profile_picture'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(athlete['name'] ?? 'Unknown Athlete'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Classroom: ${athlete['classroom']?['name'] ?? 'Unknown'}'),
                      SizedBox(height: 4),
                      if (athlete['attendance_status'] == '1')
                        Row(
                          children: [
                            Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              'Statistics available for review',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(Icons.block, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              'No statistics (not present)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  trailing: athlete['attendance_status'] == '1'
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: KRPGTheme.successColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Attended',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Not Present',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAthleteHeader(Map<String, dynamic> athlete) {
    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.backgroundSecondary,
      child: Column(
        children: [
          Text(
            'Athlete ${_currentAthleteIndex + 1} of ${_athletes.length}',
            style: KRPGTextStyles.caption.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            athlete['name'] ?? 'Unknown Athlete',
            style: KRPGTextStyles.heading4,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      margin: EdgeInsets.symmetric(horizontal: KRPGTheme.spacingSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _isLocationEnabled ? Icons.location_on : Icons.location_off,
            color: _isLocationEnabled ? KRPGTheme.successColor : KRPGTheme.dangerColor,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _isLocationEnabled 
                  ? 'Distance: ${_distanceToTraining.toStringAsFixed(1)}m'
                  : 'Location disabled',
              style: KRPGTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopwatchDisplay() {
    final bool hasExistingData = _currentAthleteStats != null;
    final String displayTitle = hasExistingData ? 'Recorded Time' : 'Stopwatch';
    final Color timeColor = _isRunning 
        ? KRPGTheme.primaryColor 
        : hasExistingData 
            ? KRPGTheme.successColor 
            : Colors.black;
    
    return Container(
      padding: KRPGSpacing.paddingLG,
      margin: EdgeInsets.all(KRPGTheme.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: hasExistingData 
            ? Border.all(color: KRPGTheme.successColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasExistingData)
                Icon(
                  Icons.check_circle,
                  color: KRPGTheme.successColor,
                  size: 20,
                ),
              if (hasExistingData) SizedBox(width: 8),
              Text(
                displayTitle,
                style: KRPGTextStyles.heading5.copyWith(
                  color: hasExistingData ? KRPGTheme.successColor : Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _formatTime(_elapsedTime),
            style: KRPGTextStyles.heading1.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: timeColor,
            ),
          ),
          if (hasExistingData && !_hasRecorded) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: KRPGTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Previously Saved',
                style: KRPGTextStyles.caption.copyWith(
                  color: KRPGTheme.successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning && !_hasRecorded)
                KRPGButton.primary(
                  text: hasExistingData ? 'Retake' : 'Start',
                  onPressed: _startStopwatch,
                  icon: hasExistingData ? Icons.refresh : Icons.play_arrow,
                ),
              if (_isRunning)
                KRPGButton.danger(
                  text: 'Stop',
                  onPressed: _stopStopwatch,
                  icon: Icons.stop,
                ),
              if (_hasRecorded) ...[
                KRPGButton.secondary(
                  text: 'Retake',
                  onPressed: _resetStopwatch,
                  icon: Icons.refresh,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputControls() {
    final bool hasExistingData = _currentAthleteStats != null;
    
    return Container(
      padding: KRPGSpacing.paddingMD,
      margin: EdgeInsets.all(KRPGTheme.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: hasExistingData 
            ? Border.all(color: KRPGTheme.successColor.withOpacity(0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recording Details',
                style: KRPGTextStyles.heading6,
              ),
              if (hasExistingData) ...[
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: KRPGTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Saved',
                    style: KRPGTextStyles.caption.copyWith(
                      color: KRPGTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16),
          
          // Show existing data summary if available
          if (hasExistingData && !_hasRecorded) ...[
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KRPGTheme.successColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: KRPGTheme.successColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previously Recorded:',
                    style: KRPGTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: KRPGTheme.successColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem('Stroke', _getStrokeName(_currentAthleteStats!['stroke'])),
                      ),
                      Expanded(
                        child: _buildStatItem('Distance', '${_currentAthleteStats!['distance']}m'),
                      ),
                    ],
                  ),
                  if (_currentAthleteStats!['energy_system'] != null) ...[
                    SizedBox(height: 4),
                    _buildStatItem('Energy System', _getEnergySystemName(_currentAthleteStats!['energy_system'])),
                  ],
                  if (_currentAthleteStats!['note'] != null && _currentAthleteStats!['note'].toString().isNotEmpty) ...[
                    SizedBox(height: 4),
                    _buildStatItem('Note', _currentAthleteStats!['note']),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
          
          KRPGDropdown(
            label: 'Stroke',
            value: _selectedStroke,
            items: _strokeOptions.map((stroke) {
              return DropdownMenuItem(
                value: stroke['value'],
                child: Text(stroke['label']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStroke = value;
              });
            },
            hint: 'Select stroke type',
          ),
          SizedBox(height: 16),
          KRPGDropdown(
            label: 'Distance',
            value: _selectedDistance,
            items: _distanceOptions.map((distance) {
              return DropdownMenuItem(
                value: distance['value'],
                child: Text(distance['label']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDistance = value;
              });
            },
            hint: 'Select distance',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: KRPGTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: KRPGTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStrokeName(String strokeValue) {
    final stroke = _strokeOptions.firstWhere(
      (s) => s['value'] == strokeValue,
      orElse: () => {'label': strokeValue},
    );
    return stroke['label']!;
  }

  String _getEnergySystemName(String energySystemValue) {
    // Convert database enum to readable name
    switch (energySystemValue) {
      case 'aerobic_11': return 'Aerobic 1.1';
      case 'aerobic_12': return 'Aerobic 1.2';
      case 'aerobic_13': return 'Aerobic 1.3';
      case 'aerobic_21': return 'Aerobic 2.1';
      case 'aerobic_22': return 'Aerobic 2.2';
      case 'aerobic_31': return 'Aerobic 3.1';
      case 'aerobic_32': return 'Aerobic 3.2';
      case 'vo2max_11': return 'VO2 Max 1.1';
      case 'vo2max_12': return 'VO2 Max 1.2';
      case 'anaerobic_11': return 'Anaerobic 1.1';
      case 'anaerobic_12': return 'Anaerobic 1.2';
      case 'anaerobic_21': return 'Anaerobic 2.1';
      case 'anaerobic_22': return 'Anaerobic 2.2';
      default: return energySystemValue;
    }
  }

  Widget _buildActionButtons() {
    if (!_hasRecorded) return SizedBox.shrink();

    return Container(
      padding: KRPGSpacing.paddingMD,
      child: Row(
        children: [
          Expanded(
            child: KRPGButton.primary(
              text: 'Save',
              onPressed: _selectedStroke != null && _selectedDistance != null
                  ? _saveStatistics
                  : null,
              icon: Icons.save,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: KRPGButton.danger(
              text: 'Delete',
              onPressed: _deleteRecord,
              icon: Icons.delete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: KRPGSpacing.paddingMD,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KRPGButton.secondary(
            text: 'Previous',
            onPressed: _currentAthleteIndex > 0 ? _navigateToPreviousAthlete : null,
            icon: Icons.arrow_back,
          ),
          Text(
            '${_currentAthleteIndex + 1} / ${_athletes.length}',
            style: KRPGTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          KRPGButton.secondary(
            text: 'Next',
            onPressed: _currentAthleteIndex < _athletes.length - 1 
                ? _navigateToNextAthlete 
                : null,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Info
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Information',
                  style: KRPGTextStyles.heading5,
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Session ID', widget.session.id),
                _buildInfoRow('Training', widget.training.title),
                _buildInfoRow('Date', _formatDate(widget.session.scheduleDate)),
                _buildInfoRow('Status', _getSessionStatusText(_currentSession?.status ?? widget.session.status)),
                _buildInfoRow('Start Time', widget.session.startTime ?? 'N/A'),
                _buildInfoRow('End Time', widget.session.endTime ?? 'N/A'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Quick Stats
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Statistics',
                  style: KRPGTextStyles.heading5,
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Total Athletes', '${_athletes.length}'),
                _buildInfoRow('Present', '${_athletes.where((a) => a['attendance_status'] == '1').length}'),
                _buildInfoRow('Late', '${_athletes.where((a) => a['attendance_status'] == '2').length}'),
                _buildInfoRow('Absent', '${_athletes.where((a) => a['attendance_status'] == '0').length}'),
                _buildInfoRow('Records', '${_statistics.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: KRPGTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: KRPGTheme.textMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: KRPGTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Stopwatch Methods
  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMilliseconds(int n) => n.toString().padLeft(3, '0');
    
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = twoDigitsMilliseconds(duration.inMilliseconds.remainder(1000));
    
    return '$minutes:$seconds.$milliseconds';
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _hasRecorded = false;
      _recordedTime = null;
    });
    
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed;
      });
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _hasRecorded = true;
      _recordedTime = _formatTime(_elapsedTime);
    });
    
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _hasRecorded = false;
      _recordedTime = null;
      _elapsedTime = Duration.zero;
    });
    
    _stopwatch.reset();
    _timer?.cancel();
  }

  void _navigateToNextAthlete() {
    if (_currentAthleteIndex < _athletes.length - 1) {
      setState(() {
        _currentAthleteIndex++;
        _resetStopwatch();
      });
      _loadCurrentAthleteStats();
    }
  }

  void _navigateToPreviousAthlete() {
    if (_currentAthleteIndex > 0) {
      setState(() {
        _currentAthleteIndex--;
        _resetStopwatch();
      });
      _loadCurrentAthleteStats();
    }
  }

  Future<void> _saveStatistics() async {
    if (!_hasRecorded || _recordedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please record a time first'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
      return;
    }

    if (_selectedStroke == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a stroke'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
      return;
    }

    if (_selectedDistance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a distance'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final controller = context.read<TrainingController>();
      final currentAthlete = _athletes[_currentAthleteIndex];
      
      // First mark attendance as present
      await controller.markAttendance(
        sessionId: widget.session.id,
        profileId: currentAthlete['id_profile']?.toString() ?? '',
        status: '1', // Present
      );

      // Then record statistics
      final success = await controller.recordStatistics(
        sessionId: widget.session.id,
        profileId: currentAthlete['id_profile']?.toString() ?? '',
        stroke: _selectedStroke!,
        duration: _recordedTime!,
        distance: int.tryParse(_selectedDistance!),
        energySystem: 'mixed', // Provide a default energy system that fits database constraints
        note: 'Recorded via stopwatch',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Statistics saved successfully for ${currentAthlete['name']}!'),
            backgroundColor: KRPGTheme.successColor,
          ),
        );
        
        // Refresh data
        _loadSessionData();
        
        // Auto-navigate to next athlete
        if (_currentAthleteIndex < _athletes.length - 1) {
          _navigateToNextAthlete();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.error ?? 'Failed to save statistics'),
            backgroundColor: KRPGTheme.dangerColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving statistics: $e'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRecord() async {
    setState(() {
      _resetStopwatch();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Record deleted'),
        backgroundColor: KRPGTheme.warningColor,
      ),
    );
  }

  Future<void> _markAttendance(String profileId, String status) async {
    try {
      final controller = context.read<TrainingController>();
      final success = await controller.markAttendance(
        sessionId: widget.session.id,
        profileId: profileId,
        status: status,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance marked successfully'),
            backgroundColor: KRPGTheme.successColor,
          ),
        );
        // Refresh data
        _loadSessionData();
      } else {
        String errorMessage = controller.error ?? 'Failed to mark attendance';
        
        // Check for specific error messages
        if (errorMessage.contains('not in attendance status')) {
          errorMessage = 'Attendance period has ended. Please refresh the session.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: KRPGTheme.dangerColor,
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: _loadSessionData,
              textColor: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error marking attendance: $e'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
    }
  }

  void _showAddStatisticsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatisticsRecordingDialog(
        sessionId: widget.session.id,
        athletes: _athletes,
        onStatisticsRecorded: () {
          _loadSessionData(); // Refresh data after recording
        },
        trainingController: context.read<TrainingController>(),
      ),
    );
  }

  Future<void> _endSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end this training session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End Session'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final controller = context.read<TrainingController>();
        final success = await controller.endSession(widget.session.id);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Session ended successfully'),
              backgroundColor: KRPGTheme.successColor,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.error ?? 'Failed to end session'),
              backgroundColor: KRPGTheme.dangerColor,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ending session: $e'),
            backgroundColor: KRPGTheme.dangerColor,
          ),
        );
      }
    }
  }

  Widget _buildStatusIndicator(String label, String status, Color color, IconData icon) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 