import 'package:flutter/material.dart';
import '../../../components/cards/detailed_training_session_card.dart';
import '../../../components/cards/detailed_training_statistics_card.dart';
import '../../../components/cards/detailed_training_phase_card.dart';
import '../../../components/cards/detailed_profile_management_card.dart';
import '../../../components/cards/detailed_competition_result_card.dart';
import '../../../components/cards/detailed_competition_certificate_card.dart';
import '../../../components/cards/location_card.dart';
import '../../../design_system/krpg_design_system.dart';
import '../../../models/training_session_model.dart';
import '../../../models/training_statistics_model.dart';
import '../../../models/training_phase_model.dart';
import '../../../models/profile_management_model.dart';
import '../../../models/competition_result_model.dart';
import '../../../models/competition_certificate_model.dart';
import '../../../models/location_model.dart';
import '../../../models/user_model.dart';

class DetailedComponentsShowcaseScreen extends StatefulWidget {
  const DetailedComponentsShowcaseScreen({super.key});

  @override
  State<DetailedComponentsShowcaseScreen> createState() => _DetailedComponentsShowcaseScreenState();
}

class _DetailedComponentsShowcaseScreenState extends State<DetailedComponentsShowcaseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _showSearchBar = false;

  final List<String> _filters = ['All', 'Training', 'Competition', 'Profile', 'Location'];
  final List<String> _tabs = ['Detailed Cards', 'Interactive Features'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Components Showcase'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search components...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),

          // Tab Bar
          Container(
            color: Colors.grey.shade100,
            child: TabBar(
              controller: _tabController,
              labelColor: KRPGTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: KRPGTheme.primaryColor,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailedCardsTab(),
                _buildInteractiveTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCardsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Training Session Cards'),
        _buildTrainingSessionCards(),
        
        _buildSectionHeader('Training Statistics Cards'),
        _buildTrainingStatisticsCards(),
        
        _buildSectionHeader('Training Phase Cards'),
        _buildTrainingPhaseCards(),
        
        _buildSectionHeader('Profile Management Cards'),
        _buildProfileManagementCards(),
        
        _buildSectionHeader('Competition Result Cards'),
        _buildCompetitionResultCards(),
        
        _buildSectionHeader('Competition Certificate Cards'),
        _buildCompetitionCertificateCards(),
        
        _buildSectionHeader('Location Cards'),
        _buildLocationCards(),
      ],
    );
  }

  Widget _buildInteractiveTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Interactive Features'),
        _buildInteractiveFeatures(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: KRPGTextStyles.heading4.copyWith(
          color: KRPGTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildTrainingSessionCards() {
    final session1 = TrainingSession(
      id: '1',
      trainingId: '1',
      scheduleDate: DateTime.now(),
      startTime: '08:00',
      endTime: '10:00',
      startedAt: DateTime.now().subtract(const Duration(hours: 1)),
      endedAt: null,
      status: TrainingSessionStatus.recording,
      createDate: DateTime.now().subtract(const Duration(days: 1)),
      createdById: '1',
    );

    final session2 = TrainingSession(
      id: '2',
      trainingId: '2',
      scheduleDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '14:00',
      endTime: '16:00',
      startedAt: null,
      endedAt: null,
      status: TrainingSessionStatus.attendance,
      createDate: DateTime.now(),
      createdById: '1',
    );

    return Column(
      children: [
        DetailedTrainingSessionCard(session: session1),
        const SizedBox(height: 16),
        DetailedTrainingSessionCard(session: session2),
      ],
    );
  }

  Widget _buildTrainingStatisticsCards() {
    final stats1 = TrainingStatistics(
      id: '1',
      attendanceId: '1',
      profileId: '1',
      stroke: 'Freestyle',
      duration: '45:30',
      distance: '1500m',
      energySystem: 'aerobic_11',
      note: 'Good technique, maintained consistent pace',
      isDeleted: false,
    );

    final stats2 = TrainingStatistics(
      id: '2',
      attendanceId: '2',
      profileId: '2',
      stroke: 'Butterfly',
      duration: '30:15',
      distance: '800m',
      energySystem: 'anaerobic_11',
      note: 'Focus on arm recovery and breathing',
      isDeleted: false,
    );

    return Column(
      children: [
        DetailedTrainingStatisticsCard(statistics: stats1),
        const SizedBox(height: 16),
        DetailedTrainingStatisticsCard(statistics: stats2),
      ],
    );
  }

  Widget _buildTrainingPhaseCards() {
    final phase1 = TrainingPhase(
      id: '1',
      phaseName: 'Foundation Phase',
      description: 'Building basic swimming skills and endurance',
      durationWeeks: 8,
      isDeleted: false,
    );

    final phase2 = TrainingPhase(
      id: '2',
      phaseName: 'Competition Phase',
      description: 'High-intensity training for competition preparation',
      durationWeeks: 6,
      isDeleted: false,
    );

    return Column(
      children: [
        DetailedTrainingPhaseCard(phase: phase1),
        const SizedBox(height: 16),
        DetailedTrainingPhaseCard(phase: phase2),
      ],
    );
  }

  Widget _buildProfileManagementCards() {
    final profile1 = ProfileManagement(
      id: '1',
      accountId: '1',
      name: 'Alex Johnson',
      birthDate: DateTime(2005, 3, 15),
      gender: Gender.male,
      phone: '+62 812-3456-7890',
      address: 'Jl. Sudirman No. 123, Jakarta',
      profilePictureUrl: 'https://example.com/avatar1.jpg',
      classroomId: '1',
      status: ProfileStatus.active,
    );

    final profile2 = ProfileManagement(
      id: '2',
      accountId: '2',
      name: 'Sarah Williams',
      birthDate: DateTime(2004, 7, 22),
      gender: Gender.female,
      phone: '+62 813-9876-5432',
      address: 'Jl. Thamrin No. 456, Jakarta',
      profilePictureUrl: 'https://example.com/avatar2.jpg',
      classroomId: '2',
      status: ProfileStatus.active,
    );

    return Column(
      children: [
        DetailedProfileManagementCard(profile: profile1),
        const SizedBox(height: 16),
        DetailedProfileManagementCard(profile: profile2),
      ],
    );
  }

  Widget _buildCompetitionResultCards() {
    final result1 = CompetitionResult(
      id: '1',
      registeredParticipantId: '1',
      position: 1,
      timeResult: '02:15:30',
      points: 100.0,
      resultStatus: CompetitionResultStatus.completed,
      resultType: CompetitionResultType.final_,
      category: 'Men 15-17 1500m Freestyle',
      notes: 'Excellent performance, new personal best',
      createDate: DateTime.now(),
      createdById: '1',
    );

    final result2 = CompetitionResult(
      id: '2',
      registeredParticipantId: '2',
      position: 3,
      timeResult: '01:45:20',
      points: 85.0,
      resultStatus: CompetitionResultStatus.completed,
      resultType: CompetitionResultType.final_,
      category: 'Women 15-17 800m Freestyle',
      notes: 'Good race, room for improvement in turns',
      createDate: DateTime.now(),
      createdById: '1',
    );

    return Column(
      children: [
        DetailedCompetitionResultCard(result: result1),
        const SizedBox(height: 16),
        DetailedCompetitionResultCard(result: result2),
      ],
    );
  }

  Widget _buildCompetitionCertificateCards() {
    final cert1 = CompetitionCertificate(
      id: '1',
      registeredParticipantId: '1',
      certificateType: CertificateType.winner,
      certificatePath: 'https://example.com/certificates/winner_2024.pdf',
      notes: 'First place certificate for 1500m Freestyle',
      uploadDate: DateTime.now(),
      uploadedById: '1',
      isDeleted: false,
    );

    final cert2 = CompetitionCertificate(
      id: '2',
      registeredParticipantId: '2',
      certificateType: CertificateType.participation,
      certificatePath: 'https://example.com/certificates/participation_2024.pdf',
      notes: 'Participation certificate for Regional Championship',
      uploadDate: DateTime.now(),
      uploadedById: '1',
      isDeleted: false,
    );

    return Column(
      children: [
        DetailedCompetitionCertificateCard(certificate: cert1),
        const SizedBox(height: 16),
        DetailedCompetitionCertificateCard(certificate: cert2),
      ],
    );
  }

  Widget _buildLocationCards() {
    final location1 = Location(
      id: '1',
      name: 'Jakarta Aquatic Center',
      address: 'Jl. Sudirman No. 123, Jakarta Pusat',
      latitude: -6.2088,
      longitude: 106.8456,
      description: 'Olympic-size swimming pool with modern facilities',
    );

    final location2 = Location(
      id: '2',
      name: 'Bandung Swimming Complex',
      address: 'Jl. Asia Afrika No. 100, Bandung',
      latitude: -6.9175,
      longitude: 107.6191,
      description: 'Multi-pool complex for training and competitions',
    );

    return Column(
      children: [
        LocationCard(location: location1),
        const SizedBox(height: 16),
        LocationCard(location: location2),
      ],
    );
  }

  Widget _buildInteractiveFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interactive Features Demo',
                  style: KRPGTextStyles.heading5,
                ),
                const SizedBox(height: 16),
                Text(
                  '• Collapsible card sections\n'
                  '• Search and filtering\n'
                  '• Tab navigation\n'
                  '• Status badges\n'
                  '• Action buttons\n'
                  '• Real-time updates',
                  style: KRPGTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try These Features:',
                  style: KRPGTextStyles.heading6,
                ),
                const SizedBox(height: 8),
                Text(
                  '1. Tap the search icon in the app bar\n'
                  '2. Use the tab bar to switch between sections\n'
                  '3. Expand/collapse card sections\n'
                  '4. Try the search functionality',
                  style: KRPGTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Search Query:',
                  style: KRPGTextStyles.heading6,
                ),
                const SizedBox(height: 8),
                Text(
                  _searchQuery.isEmpty ? 'No search query' : _searchQuery,
                  style: KRPGTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Selected Filter:',
                  style: KRPGTextStyles.heading6,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedFilter,
                  style: KRPGTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 