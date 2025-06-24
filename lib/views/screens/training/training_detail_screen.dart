import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../models/training_model.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';
import 'training_session_screen.dart';
import 'training_session_history_screen.dart';

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
      // Load training details
      final training = await controller.getTrainingDetails(widget.training.idTraining);
      if (training != null) {
        _training = training;
      }

      // Load training athletes
      final athletes = await controller.getTrainingAthletes(widget.training.idTraining);
      if (athletes != null) {
        _athletes = athletes;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading training data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              color: Colors.white.withOpacity(0.2),
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

  String _formatTime(DateTime? time) {
    if (time == null) return 'Unknown';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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
          // Navigate to session screen
          // Note: This would need the actual session data from the result
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Training session started successfully!'),
              backgroundColor: KRPGTheme.successColor,
            ),
          );
          
          // TODO: Navigate to session screen with actual session data
          // For now, show a placeholder
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Session management screen coming soon'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.error ?? 'Failed to start training session'),
              backgroundColor: KRPGTheme.dangerColor,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training cannot be started at this time'),
            backgroundColor: KRPGTheme.dangerColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting training session: $e'),
          backgroundColor: KRPGTheme.dangerColor,
        ),
      );
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
          
          // Recent Sessions
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Sessions',
                  style: KRPGTextStyles.heading5,
                ),
                const SizedBox(height: 12),
                _buildSessionItem('Session 1', '2025-01-15', 'Completed', Colors.green),
                _buildSessionItem('Session 2', '2025-01-14', 'Completed', Colors.green),
                _buildSessionItem('Session 3', '2025-01-13', 'Cancelled', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(String title, String date, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: KRPGTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: KRPGTextStyles.bodySmall.copyWith(
                    color: KRPGTheme.textMedium,
                  ),
                ),
              ],
            ),
          ),
          KRPGBadge(
            text: status,
            backgroundColor: statusColor,
          ),
        ],
      ),
    );
  }
} 