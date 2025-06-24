import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../models/training_model.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';
import '../../../design_system/krpg_text_styles.dart';

class TrainingSessionHistoryScreen extends StatefulWidget {
  final Training training;

  const TrainingSessionHistoryScreen({
    Key? key,
    required this.training,
  }) : super(key: key);

  @override
  State<TrainingSessionHistoryScreen> createState() => _TrainingSessionHistoryScreenState();
}

class _TrainingSessionHistoryScreenState extends State<TrainingSessionHistoryScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessionHistory();
  }

  Future<void> _loadSessionHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = context.read<TrainingController>();
      
      // Load training sessions for this training
      // Note: This would need to be implemented in the controller
      // For now, we'll show a placeholder
      _sessions = [
        {
          'id': '1',
          'date': '2025-01-15',
          'start_time': '08:00',
          'end_time': '09:30',
          'status': 'completed',
          'athletes_present': 12,
          'athletes_absent': 2,
          'records_count': 8,
        },
        {
          'id': '2',
          'date': '2025-01-14',
          'start_time': '08:00',
          'end_time': '09:30',
          'status': 'completed',
          'athletes_present': 10,
          'athletes_absent': 4,
          'records_count': 6,
        },
      ];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading session history: $e')),
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
        title: Text('Session History'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Training Info Header
                _buildTrainingHeader(),
                
                // Sessions List
                Expanded(
                  child: _sessions.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: KRPGSpacing.paddingMD,
                          itemCount: _sessions.length,
                          itemBuilder: (context, index) {
                            final session = _sessions[index];
                            return _buildSessionCard(session);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildTrainingHeader() {
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
            'Training Session History',
            style: KRPGTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatChip('Total Sessions', '${_sessions.length}'),
              _buildStatChip('Completed', '${_sessions.where((s) => s['status'] == 'completed').length}'),
              _buildStatChip('Avg Attendance', _calculateAverageAttendance()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
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

  String _calculateAverageAttendance() {
    if (_sessions.isEmpty) return '0';
    
    final totalPresent = _sessions.fold<int>(0, (sum, session) {
      return sum + (session['athletes_present'] as int? ?? 0);
    });
    
    final totalAthletes = _sessions.fold<int>(0, (sum, session) {
      return sum + (session['athletes_present'] as int? ?? 0) + (session['athletes_absent'] as int? ?? 0);
    });
    
    if (totalAthletes == 0) return '0';
    return (totalPresent / totalAthletes * 100).round().toString() + '%';
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    return KRPGCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session ${session['id']}',
                      style: KRPGTextStyles.heading6,
                    ),
                    Text(
                      '${session['date']} • ${session['start_time']} - ${session['end_time']}',
                      style: KRPGTextStyles.bodySmall.copyWith(
                        color: KRPGTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              KRPGBadge(
                text: _getStatusText(session['status']),
                backgroundColor: _getStatusColor(session['status']),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Session Stats
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Present',
                  '${session['athletes_present']}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Absent',
                  '${session['athletes_absent']}',
                  Icons.cancel,
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Records',
                  '${session['records_count']}',
                  Icons.fitness_center,
                  KRPGTheme.primaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewSessionDetails(session),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KRPGTheme.primaryColor,
                    side: BorderSide(color: KRPGTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewStatistics(session),
                  icon: const Icon(Icons.analytics, size: 16),
                  label: const Text('Statistics'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KRPGTheme.secondaryColor,
                    side: BorderSide(color: KRPGTheme.secondaryColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: KRPGTextStyles.heading6.copyWith(color: color),
        ),
        Text(
          label,
          style: KRPGTextStyles.bodySmall.copyWith(
            color: KRPGTheme.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: KRPGCard(
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: KRPGTheme.textMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'No Session History',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: 8),
            Text(
              'No training sessions have been completed yet for this training.',
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'ongoing':
        return 'Ongoing';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewSessionDetails(Map<String, dynamic> session) {
    // TODO: Navigate to session details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for session ${session['id']}'),
      ),
    );
  }

  void _viewStatistics(Map<String, dynamic> session) {
    // TODO: Navigate to session statistics screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing statistics for session ${session['id']}'),
      ),
    );
  }
} 