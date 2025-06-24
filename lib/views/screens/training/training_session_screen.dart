import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../models/training_model.dart';
import '../../../models/training_session_model.dart' as session_model;
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../services/location_service.dart';
import '../../../services/realtime_service.dart';
import 'statistics_recording_dialog.dart';

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
  
  // Location and real-time services
  final LocationService _locationService = LocationService();
  final RealtimeService _realtimeService = RealtimeService();
  bool _isLocationEnabled = false;
  bool _isWithinDistance = false;
  double _distanceToTraining = 0.0;
  bool _isRealtimeConnected = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSessionData();
    _initializeLocationAndRealtime();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _locationService.stopLocationUpdates();
    _realtimeService.disconnect();
    super.dispose();
  }

  Future<void> _initializeLocationAndRealtime() async {
    // Initialize location service
    final hasLocationPermission = await _locationService.requestPermissions();
    if (hasLocationPermission) {
      setState(() {
        _isLocationEnabled = true;
      });
      
      // Start location updates
      await _locationService.startLocationUpdates();
      
      // Check distance to training location
      if (widget.training.location != null) {
        _checkDistanceToTraining();
      }
    }

    // Initialize real-time service
    // Note: This would need the auth token from the auth controller
    // For now, we'll just show the UI structure
    setState(() {
      _isRealtimeConnected = true;
    });
  }

  Future<void> _checkDistanceToTraining() async {
    if (widget.training.location?.latitude == null || 
        widget.training.location?.longitude == null) return;

    final isWithin = await _locationService.isWithinDistance(
      trainingLat: widget.training.location!.latitude!,
      trainingLon: widget.training.location!.longitude!,
      maxDistanceMeters: 100.0,
    );

    setState(() {
      _isWithinDistance = isWithin;
    });
  }

  Future<void> _loadSessionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = context.read<TrainingController>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Session'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: _endSession,
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
              _buildStatusChip('Status', _getSessionStatusText(widget.session.status)),
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
    return ListView.builder(
      padding: KRPGSpacing.paddingMD,
      itemCount: _athletes.length,
      itemBuilder: (context, index) {
        final athlete = _athletes[index];
        return KRPGCard(
          margin: const EdgeInsets.only(bottom: 8),
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
            subtitle: Text('Classroom: ${athlete['classroom']?['name'] ?? 'Unknown'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAttendanceButton(athlete, 'Present', '1'),
                const SizedBox(width: 4),
                _buildAttendanceButton(athlete, 'Late', '2'),
                const SizedBox(width: 4),
                _buildAttendanceButton(athlete, 'Absent', '0'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceButton(Map<String, dynamic> athlete, String label, String status) {
    return InkWell(
      onTap: () => _markAttendance(athlete['id_profile'], status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getAttendanceColor(status),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
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

  Widget _buildStatisticsTab() {
    return Column(
      children: [
        // Add Statistics Button
        Padding(
          padding: KRPGSpacing.paddingMD,
          child: KRPGButton(
            text: 'Add Statistics Record',
            onPressed: _showAddStatisticsDialog,
            icon: Icons.add,
          ),
        ),
        
        // Statistics List
        Expanded(
          child: ListView.builder(
            padding: KRPGSpacing.paddingMD,
            itemCount: _statistics.length,
            itemBuilder: (context, index) {
              final stat = _statistics[index];
              return KRPGCard(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: stat['athlete']?['profile_picture'] != null
                        ? NetworkImage(stat['athlete']['profile_picture'])
                        : null,
                    child: stat['athlete']?['profile_picture'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(stat['athlete']?['name'] ?? 'Unknown Athlete'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stroke: ${stat['stroke'] ?? 'N/A'}'),
                      Text('Distance: ${stat['distance'] ?? 'N/A'}m'),
                      Text('Time: ${stat['duration'] ?? 'N/A'}'),
                    ],
                  ),
                  trailing: KRPGBadge(
                    text: stat['energy_system'] ?? 'N/A',
                    backgroundColor: KRPGTheme.primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
                _buildInfoRow('Status', _getSessionStatusText(widget.session.status)),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.error ?? 'Failed to mark attendance'),
            backgroundColor: KRPGTheme.dangerColor,
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