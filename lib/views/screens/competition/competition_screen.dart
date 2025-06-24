import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/competition_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/cards/competition_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/forms/krpg_search_bar.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../views/screens/competition/competition_detail_screen.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _selectedLevel = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Defer the API call to after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompetitions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadCompetitions() {
    final competitionController = context.read<CompetitionController>();
    competitionController.getCompetitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitions'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<AuthController>(
            builder: (context, authController, child) {
              // Show pending approvals button for coaches and leaders
              if (authController.currentUser?.role == UserRole.coach ||
                  authController.currentUser?.role == UserRole.leader) {
                return IconButton(
                  icon: const Icon(Icons.pending_actions),
                  onPressed: () {
                    _showPendingApprovals();
                  },
                  tooltip: 'Pending Approvals',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Coming Soon'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Finished'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilterSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCompetitionList('all'),
                _buildCompetitionList('coming_soon'),
                _buildCompetitionList('ongoing'),
                _buildCompetitionList('finished'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(KRPGTheme.spacingMd),
      color: KRPGTheme.backgroundSecondary,
      child: Column(
        children: [
          KRPGSearchBar(
            hintText: 'Search competitions...',
            onChanged: (value) {
              _performSearch();
            },
          ),
          const SizedBox(height: KRPGTheme.spacingSm),
          _buildFilters(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        _buildStatusFilter(),
        const SizedBox(height: KRPGTheme.spacingSm),
        _buildLevelFilter(),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', 'all', _selectedStatus),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Coming Soon', 'coming_soon', _selectedStatus),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Ongoing', 'ongoing', _selectedStatus),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Finished', 'finished', _selectedStatus),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Cancelled', 'cancelled', _selectedStatus),
        ],
      ),
    );
  }

  Widget _buildLevelFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All Levels', 'all', _selectedLevel),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Local', 'local', _selectedLevel),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Regional', 'regional', _selectedLevel),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('National', 'national', _selectedLevel),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('International', 'international', _selectedLevel),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String selectedValue) {
    final isSelected = selectedValue == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selectedValue == _selectedStatus) {
            _selectedStatus = selected ? value : 'all';
          } else {
            _selectedLevel = selected ? value : 'all';
          }
        });
        _performSearch();
      },
      selectedColor: KRPGTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: KRPGTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? KRPGTheme.primaryColor : KRPGTheme.textMedium,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildCompetitionList(String status) {
    return Consumer<CompetitionController>(
      builder: (context, competitionController, child) {
        if (competitionController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (competitionController.error != null) {
          return _buildErrorState(competitionController);
        }

        final competitions = competitionController.competitions;
        if (competitions.isEmpty) {
          return _buildEmptyState(status);
        }

        // Filter competitions based on status and level
        final filteredCompetitions = competitions.where((competition) {
          final statusMatch = status == 'all' || 
              competition.status.toString().toLowerCase() == status;
          final levelMatch = _selectedLevel == 'all' || 
              competition.competitionLevel.toString().toLowerCase() == _selectedLevel;
          return statusMatch && levelMatch;
        }).toList();

        if (filteredCompetitions.isEmpty) {
          return _buildEmptyState(status);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await competitionController.getCompetitions();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            itemCount: filteredCompetitions.length,
            itemBuilder: (context, index) {
              final competition = filteredCompetitions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: KRPGTheme.spacingMd),
                child: CompetitionCard(
                  competition: competition,
                  onTap: () {
                    _showCompetitionDetails(competition);
                  },
                  onRegister: () {
                    _registerForCompetition(competition.idCompetition);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(CompetitionController competitionController) {
    return Center(
      child: KRPGCard(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: KRPGTheme.dangerColor,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            Text(
              'Failed to load competitions',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              competitionController.error ?? 'Unknown error occurred',
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            KRPGButton(
              text: 'Retry',
              onPressed: () {
                competitionController.getCompetitions();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: KRPGCard(
        child: Column(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 48,
              color: KRPGTheme.textMedium,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            Text(
              'No competitions found',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              status == 'all'
                  ? 'No competitions are available at the moment.'
                  : 'No $status competitions found.',
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

  Widget _buildFloatingActionButton() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        // Only show FAB for coaches and leaders
        if (authController.currentUser?.role != UserRole.coach &&
            authController.currentUser?.role != UserRole.leader) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: () {
            _showCreateCompetitionDialog();
          },
          backgroundColor: KRPGTheme.primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        );
      },
    );
  }

  void _performSearch() {
    // Defer the search to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final competitionController = context.read<CompetitionController>();
      final searchTerm = _searchController.text.trim();
      
      competitionController.getCompetitions(
        search: searchTerm.isNotEmpty ? searchTerm : null,
        status: _selectedStatus != 'all' ? _selectedStatus : null,
        level: _selectedLevel != 'all' ? _selectedLevel : null,
      );
    });
  }

  void _showCompetitionDetails(dynamic competition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompetitionDetailScreen(
          competition: competition,
        ),
      ),
    );
  }

  void _registerForCompetition(String competitionId) {
    final competitionController = context.read<CompetitionController>();
    competitionController.registerForCompetition(competitionId: competitionId).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration submitted successfully!'),
            backgroundColor: KRPGTheme.successColor,
          ),
        );
        // Refresh the list
        competitionController.getCompetitions();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(competitionController.error ?? 'Failed to register'),
            backgroundColor: KRPGTheme.dangerColor,
          ),
        );
      }
    });
  }

  void _showPendingApprovals() {
    // TODO: Navigate to pending approvals screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pending approvals functionality coming soon'),
      ),
    );
  }

  void _showCreateCompetitionDialog() {
    // TODO: Implement create competition dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create competition functionality coming soon'),
      ),
    );
  }
} 