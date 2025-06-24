import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../controllers/athletes_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/cards/athlete_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/forms/krpg_search_bar.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../views/screens/athletes/athlete_detail_screen.dart';

class AthletesScreen extends StatefulWidget {
  const AthletesScreen({super.key});

  @override
  State<AthletesScreen> createState() => _AthletesScreenState();
}

class _AthletesScreenState extends State<AthletesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedClassroom = 'all';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Defer the API call to after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAthletes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _loadAthletes() {
    final athletesController = context.read<AthletesController>();
    athletesController.getAthletes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athletes'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Athletes'),
            Tab(text: 'My Profile'),
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
                _buildAthletesList(),
                _buildMyProfile(),
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
            hintText: 'Search athletes...',
            onChanged: (value) {
              // Use debounced search to avoid setState during build
              if (_debounceTimer?.isActive ?? false) {
                _debounceTimer?.cancel();
              }
              
              _debounceTimer = Timer(const Duration(milliseconds: 500), () {
              _performSearch();
              });
            },
          ),
          const SizedBox(height: KRPGTheme.spacingSm),
          _buildClassroomFilter(),
        ],
      ),
    );
  }

  Widget _buildClassroomFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All Classrooms', 'all'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Class A', 'class_a'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Class B', 'class_b'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Advanced', 'advanced'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedClassroom == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedClassroom = selected ? value : 'all';
        });
        // Use a post-frame callback to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch();
        });
      },
      selectedColor: KRPGTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: KRPGTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? KRPGTheme.primaryColor : KRPGTheme.textMedium,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildAthletesList() {
    return Consumer<AthletesController>(
      builder: (context, athletesController, child) {
        if (athletesController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (athletesController.error != null) {
          return _buildErrorState(athletesController);
        }

        final athletes = athletesController.athletes;
        if (athletes.isEmpty) {
          return _buildEmptyState();
        }

        // Filter athletes based on classroom
        final filteredAthletes = athletes.where((athlete) {
          if (_selectedClassroom == 'all') return true;
          // TODO: Implement proper classroom filtering
          return true;
        }).toList();

        if (filteredAthletes.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await athletesController.getAthletes();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            itemCount: filteredAthletes.length,
            itemBuilder: (context, index) {
              final athlete = filteredAthletes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: KRPGTheme.spacingMd),
                child: KRPGCard(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: KRPGTheme.primaryColor,
                      ),
                    ),
                    title: Text(
                      athlete['name'] ?? 'Unknown Athlete',
                      style: KRPGTextStyles.cardTitle,
                    ),
                    subtitle: Text(
                      athlete['email'] ?? 'No email',
                      style: KRPGTextStyles.bodyMediumSecondary,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: KRPGTheme.textMedium,
                      size: 16,
                    ),
                    onTap: () {
                      _showAthleteDetails(athlete);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyProfile() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final currentUser = authController.currentUser;
        if (currentUser == null) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            children: [
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: KRPGTheme.primaryColor,
                          child: Text(
                            currentUser.profile?.name.substring(0, 1).toUpperCase() ?? 'U',
                            style: KRPGTextStyles.heading4.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: KRPGTheme.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser.profile?.name ?? 'Unknown User',
                                style: KRPGTextStyles.heading5,
                              ),
                              Text(
                                currentUser.role.displayName,
                                style: KRPGTextStyles.bodyMedium.copyWith(
                                  color: KRPGTheme.textMedium,
                                ),
                              ),
                              Text(
                                currentUser.email,
                                style: KRPGTextStyles.bodySmall.copyWith(
                                  color: KRPGTheme.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    _buildProfileDetail('Phone', currentUser.profile?.phoneNumber ?? 'Not set'),
                    _buildProfileDetail('Address', currentUser.profile?.address ?? 'Not set'),
                    _buildProfileDetail('Birth Date', currentUser.profile?.birthDate?.toString() ?? 'Not set'),
                    _buildProfileDetail('Gender', currentUser.profile?.gender?.value ?? 'Not set'),
                  ],
                ),
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              KRPGButton(
                text: 'Edit Profile',
                onPressed: () {
                  _showEditProfileDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KRPGTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: KRPGTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
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

  Widget _buildErrorState(AthletesController athletesController) {
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
              'Failed to load athletes',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              athletesController.error ?? 'Unknown error occurred',
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            KRPGButton(
              text: 'Retry',
              onPressed: () {
                athletesController.getAthletes();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: KRPGCard(
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: KRPGTheme.textMedium,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            Text(
              'No athletes found',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              'No athletes are available at the moment.',
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
            _showAddAthleteDialog();
          },
          backgroundColor: KRPGTheme.primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.person_add),
        );
      },
    );
  }

  void _performSearch() {
    final athletesController = context.read<AthletesController>();
    final searchTerm = _searchController.text.trim();
    
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    athletesController.getAthletes(
      search: searchTerm.isNotEmpty ? searchTerm : null,
    );
    });
  }

  void _showAthleteDetails(Map<String, dynamic> athlete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AthleteDetailScreen(
          athlete: athlete,
        ),
      ),
    );
  }

  void _showAthleteHistory(String athleteId) {
    // TODO: Navigate to athlete history screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('History for athlete: $athleteId'),
      ),
    );
  }

  void _showEditProfileDialog() {
    // TODO: Implement edit profile dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile functionality coming soon'),
      ),
    );
  }

  void _showAddAthleteDialog() {
    // TODO: Implement add athlete dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add athlete functionality coming soon'),
      ),
    );
  }
} 