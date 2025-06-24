import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/competition_controller.dart';
import '../../../models/competition_model.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_spacing.dart';

class CompetitionDetailScreen extends StatefulWidget {
  final Competition competition;

  const CompetitionDetailScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  State<CompetitionDetailScreen> createState() => _CompetitionDetailScreenState();
}

class _CompetitionDetailScreenState extends State<CompetitionDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  Competition? _competition;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCompetitionData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCompetitionData() async {
    final controller = context.read<CompetitionController>();
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Load competition details
      final competition = await controller.getCompetitionDetails(widget.competition.idCompetition);
      if (competition != null) {
        _competition = competition;
      }

      // Load competition stats
      final stats = await controller.getCompetitionStats();
      if (stats != null) {
        _stats = stats;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading competition data: $e')),
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
        title: Text(widget.competition.competitionName),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit competition screen
            },
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
                      _buildStatisticsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderSection() {
    if (_competition == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: KRPGSpacing.paddingMD,
      color: KRPGTheme.primaryColor,
      child: Column(
        children: [
          // Competition Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 40,
              color: Colors.white,
            ),
          ),
          KRPGSpacing.verticalSM,
          
          // Competition Name
          Text(
            _competition!.competitionName,
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
              _buildInfoItem('Date', _competition!.formattedDate),
              _buildInfoItem('Location', _competition!.location ?? 'Unknown'),
              _buildInfoItem('Level', _competition!.competitionLevel?.name ?? 'Unknown'),
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
    if (_competition == null) {
      return const Center(child: Text('No competition data available'));
    }

    return SingleChildScrollView(
      padding: KRPGSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Competition Information
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Competition Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Name', _competition!.competitionName),
                _buildInfoRow('Date', _competition!.formattedDate),
                _buildInfoRow('Location', _competition!.location ?? 'Unknown'),
                _buildInfoRow('Level', _competition!.competitionLevel?.name ?? 'Unknown'),
                _buildInfoRow('Organizer', _competition!.organizer ?? 'Unknown'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Registration Information
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registration Information',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Registration Start', _formatDate(_competition!.startRegisterTime)),
                _buildInfoRow('Registration End', _formatDate(_competition!.endRegisterTime)),
                _buildInfoRow('Status', _competition!.status.name),
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
                  _buildInfoRow('Total Competitions', '${_stats!['total_competitions'] ?? 0}'),
                  _buildInfoRow('Active Competitions', '${_stats!['active_competitions'] ?? 0}'),
                  _buildInfoRow('Completed Competitions', '${_stats!['completed_competitions'] ?? 0}'),
                ],
              ),
            ),
          ],
        ],
      ),
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
                _buildStatRow('Active Competitions', '${_stats!['active_competitions'] ?? 0}'),
                _buildStatRow('Completed Competitions', '${_stats!['completed_competitions'] ?? 0}'),
                _buildStatRow('Upcoming Competitions', '${_stats!['upcoming_competitions'] ?? 0}'),
              ],
            ),
          ),
          
          KRPGSpacing.verticalMD,
          
          // Level Distribution
          KRPGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level Distribution',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatRow('Beginner', '${_stats!['beginner_competitions'] ?? 0}'),
                _buildStatRow('Intermediate', '${_stats!['intermediate_competitions'] ?? 0}'),
                _buildStatRow('Advanced', '${_stats!['advanced_competitions'] ?? 0}'),
                _buildStatRow('Professional', '${_stats!['professional_competitions'] ?? 0}'),
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
            width: 140,
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
} 