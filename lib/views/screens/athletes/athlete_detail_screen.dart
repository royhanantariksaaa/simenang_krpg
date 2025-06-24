import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/athletes_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';

class AthleteDetailScreen extends StatefulWidget {
  final Map<String, dynamic> athlete;

  const AthleteDetailScreen({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  @override
  State<AthleteDetailScreen> createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Map<String, dynamic>? _athlete;
  List<Map<String, dynamic>> _trainingHistory = [];
  List<Map<String, dynamic>> _competitionHistory = [];
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAthleteData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAthleteData() async {
    final controller = context.read<AthletesController>();
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Load athlete details
      final athlete = await controller.getAthleteDetail(widget.athlete['id']);
      if (athlete != null) {
        _athlete = athlete;
      }

      // Load training history
      final trainingHistory = await controller.getAthleteTrainingHistory(widget.athlete['id']);
      if (trainingHistory != null) {
        _trainingHistory = trainingHistory;
      }

      // Load competition history
      final competitionHistory = await controller.getAthleteCompetitionHistory(widget.athlete['id']);
      if (competitionHistory != null) {
        _competitionHistory = competitionHistory;
      }

      // Load athlete stats
      final stats = await controller.getAthleteStats();
      if (stats != null) {
        _stats = stats;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading athlete data: $e')),
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
        title: Text(widget.athlete['name'] ?? 'Unknown'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit athlete screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Profile Section
                _buildProfileSection(),
                
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
                      Tab(text: 'Training'),
                      Tab(text: 'Competitions'),
                      Tab(text: 'Statistics'),
                    ],
                  ),
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildTrainingTab(),
                      _buildCompetitionsTab(),
                      _buildStatisticsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileSection() {
    if (_athlete == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage: _athlete!['profile_picture'] != null
                ? NetworkImage(_athlete!['profile_picture'])
                : null,
            child: _athlete!['profile_picture'] == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          KRPGSpacing.verticalSM,
          
          // Name
          Text(
            _athlete!['name'] ?? 'Unknown',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          // Status Badge
          KRPGSpacing.verticalSM,
          KRPGBadge(
            text: _athlete!['status'] ?? 'Unknown',
            backgroundColor: _getStatusColor(_athlete!['status']),
          ),
          
          // Basic Info
          KRPGSpacing.verticalMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('Age', '${_calculateAge(_athlete!['birth_date'])} years'),
              _buildInfoItem('Gender', _athlete!['gender'] ?? 'Unknown'),
              _buildInfoItem('City', _athlete!['city'] ?? 'Unknown'),
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
        ),
      ],
    );
  }

  int _calculateAge(String? birthDate) {
    if (birthDate == null) return 0;
    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      return now.year - birth.year - (now.month < birth.month || (now.month == birth.month && now.day < birth.day) ? 1 : 0);
    } catch (e) {
      return 0;
    }
  }

  Color _getStatusColor(String? status) {
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

  Widget _buildOverviewTab() {
    if (_athlete == null) {
      return const Center(child: Text('No athlete data available'));
    }

    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Phone', _athlete!['phone_number'] ?? 'Not provided'),
                _buildInfoRow('Parent Phone', _athlete!['phone_number_parent'] ?? 'Not provided'),
                _buildInfoRow('Address', _athlete!['address'] ?? 'Not provided'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Personal Information
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Birth Date', _athlete!['birth_date'] ?? 'Not provided'),
                _buildInfoRow('Join Date', _athlete!['join_date'] ?? 'Not provided'),
                _buildInfoRow('Classroom', _athlete!['classroom']?['name'] ?? 'Not assigned'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Quick Stats
          if (_stats != null) ...[
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
                  _buildInfoRow('Total Trainings', '${_stats!['total_trainings'] ?? 0}'),
                  _buildInfoRow('Total Competitions', '${_stats!['total_competitions'] ?? 0}'),
                  _buildInfoRow('Average Attendance', '${_stats!['average_attendance'] ?? 0}%'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrainingTab() {
    return ListView.builder(
      padding: KRPGSpacing.paddingMD,
      itemCount: _trainingHistory.length,
      itemBuilder: (context, index) {
        final training = _trainingHistory[index];
        return KRPGCard(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(training['training_name'] ?? 'Unknown Training'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${training['date'] ?? 'Unknown'}'),
                Text('Duration: ${training['duration'] ?? 'Unknown'}'),
                Text('Status: ${training['status'] ?? 'Unknown'}'),
              ],
            ),
            trailing: KRPGBadge(
              text: training['status'] ?? 'Unknown',
              backgroundColor: _getTrainingStatusColor(training['status']),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompetitionsTab() {
    return ListView.builder(
      padding: KRPGSpacing.paddingMD,
      itemCount: _competitionHistory.length,
      itemBuilder: (context, index) {
        final competition = _competitionHistory[index];
        return KRPGCard(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(competition['competition_name'] ?? 'Unknown Competition'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${competition['competition_date'] ?? 'Unknown'}'),
                Text('Location: ${competition['competition_location'] ?? 'Unknown'}'),
                if (competition['result'] != null) ...[
                  Text('Position: ${competition['result']['final_position'] ?? 'Unknown'}'),
                  Text('Time: ${competition['result']['time_result'] ?? 'Unknown'}'),
                ],
              ],
            ),
            trailing: competition['result'] != null
                ? KRPGBadge(
                    text: '${competition['result']['final_position']}',
                    backgroundColor: _getCompetitionResultColor(competition['result']['final_position']),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    if (_stats == null) {
      return const Center(child: Text('No statistics available'));
    }

    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        children: [
          // Training Statistics
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training Statistics',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Total Trainings', '${_stats!['total_trainings'] ?? 0}'),
                _buildStatRow('Completed Trainings', '${_stats!['completed_trainings'] ?? 0}'),
                _buildStatRow('Average Attendance', '${_stats!['average_attendance'] ?? 0}%'),
                _buildStatRow('Total Training Hours', '${_stats!['total_training_hours'] ?? 0}'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Competition Statistics
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Competition Statistics',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Total Competitions', '${_stats!['total_competitions'] ?? 0}'),
                _buildStatRow('Wins', '${_stats!['competition_wins'] ?? 0}'),
                _buildStatRow('Average Position', '${_stats!['average_position'] ?? 0}'),
                _buildStatRow('Best Time', '${_stats!['best_time'] ?? 'N/A'}'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Performance Statistics
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Statistics',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Current Level', '${_stats!['current_level'] ?? 'N/A'}'),
                _buildStatRow('Progress Score', '${_stats!['progress_score'] ?? 0}'),
                _buildStatRow('Last Assessment', '${_stats!['last_assessment_date'] ?? 'N/A'}'),
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
            width: 100,
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: KRPGTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrainingStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getCompetitionResultColor(dynamic position) {
    if (position == null) return Colors.grey;
    
    final pos = int.tryParse(position.toString());
    if (pos == null) return Colors.grey;
    
    if (pos == 1) return Colors.amber;
    if (pos == 2) return Colors.grey;
    if (pos == 3) return Colors.brown;
    return Colors.blue;
  }
} 