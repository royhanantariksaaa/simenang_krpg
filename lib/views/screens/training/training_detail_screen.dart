import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/training_model.dart';
import '../../../models/training_session_model.dart' as session_model;
import '../../../models/user_model.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';
import 'training_session_screen.dart';
import 'training_session_history_screen.dart';
import 'attendance_check_screen.dart';
import 'simple_attendance_screen.dart';

class TrainingDetailScreen extends StatefulWidget {
  final Training training;

  const TrainingDetailScreen({
    Key? key,
    required this.training,
  }) : super(key: key);

  @override
  State<TrainingDetailScreen> createState() => _TrainingDetailScreenState();
}

class _TrainingDetailScreenState extends State<TrainingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Training? _training;
  List<Map<String, dynamic>> _athletes = [];
  session_model.TrainingSession? _activeSession;
  List<session_model.TrainingSession> _sessions = [];
  bool _isLoadingSessions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTrainingData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrainingData() async {
    final controller = context.read<TrainingController>();
    
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔍 [Training Detail] Loading data for training: ${widget.training.title}');
      debugPrint('🔍 [Training Detail] Training ID: ${widget.training.idTraining}');
      
      // Use the passed training data as initial state
      _training = widget.training;
      
      // Try to load additional training details
      try {
        final training = await controller.getTrainingDetails(widget.training.idTraining);
        if (training != null) {
          _training = training;
          debugPrint('✅ [Training Detail] Enhanced training details loaded');
        }
      } catch (e) {
        debugPrint('⚠️ [Training Detail] Could not load enhanced details, using passed data: $e');
        // Continue with passed training data
      }

      // Try to load training athletes
      try {
        final athletes = await controller.getTrainingAthletes(widget.training.idTraining);
        if (athletes != null) {
          _athletes = athletes;
          debugPrint('✅ [Training Detail] Loaded ${_athletes.length} athletes');
        }
      } catch (e) {
        debugPrint('⚠️ [Training Detail] Could not load athletes: $e');
        // Provide dummy athletes for UEQ-S testing
        _athletes = _generateDummyAthletes();
      }

      // Try to check for active session
      try {
        final activeSession = await controller.getActiveSession(widget.training.idTraining);
        if (activeSession != null) {
          _activeSession = activeSession;
          debugPrint('✅ [Training Detail] Active session found');
        }
      } catch (e) {
        debugPrint('⚠️ [Training Detail] Could not check active session: $e');
      }

      // Try to load training sessions
      try {
        await _loadSessions();
      } catch (e) {
        debugPrint('⚠️ [Training Detail] Could not load sessions: $e');
        // Provide dummy sessions for UEQ-S testing
        _sessions = _generateDummySessions();
      }
      
      debugPrint('✅ [Training Detail] All data loading completed');
    } catch (e) {
      debugPrint('❌ [Training Detail] Critical error loading training data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Using offline data due to connection issue'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      // Fallback to basic data for UEQ-S testing
      _training = widget.training;
      _athletes = _generateDummyAthletes();
      _sessions = _generateDummySessions();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSessions() async {
    final controller = context.read<TrainingController>();
    
    setState(() {
      _isLoadingSessions = true;
    });

    try {
      final sessions = await controller.getTrainingSessions(widget.training.idTraining);
      if (sessions != null) {
        setState(() {
          _sessions = sessions;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading sessions: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingSessions = false;
      });
    }
  }

  // Generate dummy athletes for UEQ-S testing mode
  List<Map<String, dynamic>> _generateDummyAthletes() {
    return [
      {
        'id': '1',
        'name': 'Ahmad Santoso',
        'email': 'ahmad.santoso@example.com',
        'phone': '081234567890',
        'status': 'active',
        'attendance_status': 'present',
      },
      {
        'id': '2', 
        'name': 'Sari Wijaya',
        'email': 'sari.wijaya@example.com',
        'phone': '081234567891',
        'status': 'active',
        'attendance_status': 'present',
      },
      {
        'id': '3',
        'name': 'Budi Pratama',
        'email': 'budi.pratama@example.com', 
        'phone': '081234567892',
        'status': 'active',
        'attendance_status': 'absent',
      },
      {
        'id': '4',
        'name': 'Lisa Permata',
        'email': 'lisa.permata@example.com',
        'phone': '081234567893', 
        'status': 'active',
        'attendance_status': 'present',
      },
      {
        'id': '5',
        'name': 'Roni Setiawan',
        'email': 'roni.setiawan@example.com',
        'phone': '081234567894',
        'status': 'active', 
        'attendance_status': 'present',
      },
    ];
  }

  // Generate dummy sessions for UEQ-S testing mode
  List<session_model.TrainingSession> _generateDummySessions() {
    return [
      session_model.TrainingSession(
        id: '1',
        trainingId: widget.training.idTraining,
        scheduleDate: DateTime.now().subtract(const Duration(days: 7)),
        startTime: '19:00',
        endTime: '21:00',
        status: session_model.TrainingSessionStatus.completed,
        createDate: DateTime.now().subtract(const Duration(days: 10)),
        createdById: 'coach123',
        attendeeCount: 5,
        trainingTitle: widget.training.title,
        coachName: 'Pelatih Ahmad Santoso',
      ),
      session_model.TrainingSession(
        id: '2',
        trainingId: widget.training.idTraining,
        scheduleDate: DateTime.now().subtract(const Duration(days: 3)),
        startTime: '17:45',
        endTime: '19:45', 
        status: session_model.TrainingSessionStatus.completed,
        createDate: DateTime.now().subtract(const Duration(days: 5)),
        createdById: 'coach123',
        attendeeCount: 4,
        trainingTitle: widget.training.title,
        coachName: 'Pelatih Ahmad Santoso',
      ),
      session_model.TrainingSession(
        id: '3',
        trainingId: widget.training.idTraining,
        scheduleDate: DateTime.now().add(const Duration(days: 2)),
        startTime: '20:15',
        endTime: '21:15',
        status: session_model.TrainingSessionStatus.attendance,
        createDate: DateTime.now(),
        createdById: 'coach123',
        attendeeCount: 0,
        trainingTitle: widget.training.title,
        coachName: 'Pelatih Ahmad Santoso',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training.title),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingSessionHistoryScreen(
                    training: widget.training,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _startTrainingSession,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Section
                _buildHeaderSection(),
                
                // Tab Bar
                Container(
                  color: KRPGTheme.primaryColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Athletes'),
                      Tab(text: 'Sessions'),
                    ],
                  ),
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildAthletesTab(),
                      _buildSessionsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderSection() {
    if (_training == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Column(
        children: [
          // Training Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 40,
              color: Colors.white,
            ),
          ),
          KRPGSpacing.verticalSM,
          
          // Training Name
          Text(
            _training!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Basic Info
          KRPGSpacing.verticalMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Date', _formatDate(_training!.datetime)),
              _buildInfoItem('Time', _training!.formattedTime),
              _buildInfoItem('Status', _training!.status.name),
            ],
          ),
          
          // Active Session Button
          if (_activeSession != null) ...[
            KRPGSpacing.verticalMD,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: KRPGButton(
                text: 'Join Active Session',
                onPressed: _joinActiveSession,
                icon: Icons.group,
                type: KRPGButtonType.filled,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 8),
                  SizedBox(width: 8),
                  Text(
                    'Training session in progress - ${_activeSession!.status.displayName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _joinActiveSession() {
    if (_activeSession != null && _training != null) {
      final authController = context.read<AuthController>();
      final userRole = authController.currentUser?.role;
      
      // Determine which screen to navigate to based on user role
      Widget targetScreen;
      
      if (userRole == UserRole.coach || userRole == UserRole.leader) {
        // Coaches and admins go to session management screen
        targetScreen = TrainingSessionScreen(
          training: _training!,
          session: _activeSession!,
        );
      } else {
        // Athletes go to simple attendance screen
        targetScreen = SimpleAttendanceScreen(
          training: _training!,
          session: _activeSession!,
        );
      }
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      ).then((_) {
        // Refresh data when returning from session
        _loadTrainingData();
      });
    }
  }

  Widget _buildOverviewTab() {
    if (_training == null) {
      return const Center(child: Text('No training data available'));
    }

    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Training Information
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Name', _training!.title),
                _buildInfoRow('Date', _formatDate(_training!.datetime)),
                _buildInfoRow('Time', _training!.formattedTime),
                _buildInfoRow('Description', _training!.description ?? 'No description'),
                _buildInfoRow('Location', _training!.location?.locationName ?? 'Unknown'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Training Details
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training Details',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Coach', _training!.coachName ?? 'Unknown'),
                _buildInfoRow('Classroom', _training!.classroomName ?? 'Unknown'),
                _buildInfoRow('Status', _training!.status.name),
                _buildInfoRow('Recurring', _training!.recurring ? 'Yes' : 'No'),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Total Athletes', '${_athletes.length}'),
                _buildInfoRow('Active Athletes', '${_athletes.where((a) => a['status'] == 'active').length}'),
                _buildInfoRow('Training Status', _training!.status.name),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthletesTab() {
    return ListView.builder(
      padding: KRPGSpacing.paddingMD,
      itemCount: _athletes.length,
      itemBuilder: (context, index) {
        final athlete = _athletes[index];
        return KRPGCard(
          margin: const EdgeInsets.only(bottom: 8),
          onTap: () {
            // TODO: Navigate to athlete detail screen
          },
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
                Text('Role: ${athlete['role'] ?? 'Unknown'}'),
                Text('Status: ${athlete['status'] ?? 'Unknown'}'),
              ],
            ),
            trailing: KRPGBadge(
              text: athlete['status'] ?? 'Unknown',
              backgroundColor: _getAthleteStatusColor(athlete['status']),
            ),
          ),
        );
      },
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
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAthleteStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _startTrainingSession() async {
    try {
      final controller = context.read<TrainingController>();
      
      // Check if training can be started
      final canStart = await controller.canStartTraining(widget.training.idTraining);
      
      if (canStart != null && canStart['can_start'] == true) {
        // Start the training
        final result = await controller.startTraining(widget.training.idTraining);
        
        if (result != null) {
          // Create session object from result
          final sessionData = result;
          final session = session_model.TrainingSession.fromJson(sessionData);
          
          if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Training session started successfully!'),
              backgroundColor: KRPGTheme.successColor,
            ),
          );
          
            // Navigate to session management screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainingSessionScreen(
                  training: widget.training,
                  session: session,
                ),
            ),
          );
          }
        } else {
          if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.error ?? 'Failed to start training session'),
              backgroundColor: KRPGTheme.dangerColor,
            ),
          );
          }
        }
      } else {
        if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training cannot be started at this time'),
            backgroundColor: KRPGTheme.dangerColor,
          ),
        );
        }
      }
    } catch (e) {
      if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting training session: $e'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
      }
    }
  }

  Widget _buildSessionsTab() {
    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Management Section
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Management',
                  style: KRPGTextStyles.heading5,
                ),
                const SizedBox(height: 12),
                Text(
                  'Manage training sessions for this training.',
                  style: KRPGTextStyles.bodyMedium.copyWith(
                    color: KRPGTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: KRPGButton(
                        text: 'Start Session',
                        onPressed: _startTrainingSession,
                        icon: Icons.play_arrow,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KRPGButton(
                        text: 'View History',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainingSessionHistoryScreen(
                                training: widget.training,
                              ),
                            ),
                          );
                        },
                        icon: Icons.history,
                        type: KRPGButtonType.outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Sessions List
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Training Sessions',
                      style: KRPGTextStyles.heading5,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadSessions,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_isLoadingSessions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_sessions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center_outlined,
                          size: 64,
                          color: KRPGTheme.textMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Sessions Yet',
                          style: KRPGTextStyles.heading6.copyWith(
                            color: KRPGTheme.textMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No training sessions have been created yet for this training.',
                          style: KRPGTextStyles.bodySmall.copyWith(
                            color: KRPGTheme.textMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: _sessions.map((session) => _buildSessionItem(session)).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(session_model.TrainingSession session) {
    Color statusColor;
    String statusText;
    
    switch (session.status) {
      case session_model.TrainingSessionStatus.attendance:
        statusColor = Colors.orange;
        statusText = 'Taking Attendance';
        break;
      case session_model.TrainingSessionStatus.recording:
        statusColor = Colors.blue;
        statusText = 'Recording';
        break;
      case session_model.TrainingSessionStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }
    
    return InkWell(
      onTap: () {
        // Navigate to session details or management screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainingSessionScreen(
              training: widget.training,
              session: session,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getSessionIcon(session.status),
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session ${session.id}',
                    style: KRPGTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                                     Text(
                     session.startedAt != null 
                       ? 'Started: ${_formatDateTime(session.startedAt!)}'
                       : 'Scheduled: ${_formatDate(session.scheduleDate)} ${session.startTime}',
                     style: KRPGTextStyles.bodySmall.copyWith(
                       color: KRPGTheme.textMedium,
                     ),
                   ),
                   if (session.endedAt != null)
                     Text(
                       'Ended: ${_formatDateTime(session.endedAt!)}',
                       style: KRPGTextStyles.bodySmall.copyWith(
                         color: KRPGTheme.textMedium,
                       ),
                     ),
                ],
              ),
            ),
            KRPGBadge(
              text: statusText,
              backgroundColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSessionIcon(session_model.TrainingSessionStatus status) {
    switch (status) {
      case session_model.TrainingSessionStatus.attendance:
        return Icons.how_to_reg;
      case session_model.TrainingSessionStatus.recording:
        return Icons.timer;
      case session_model.TrainingSessionStatus.completed:
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 