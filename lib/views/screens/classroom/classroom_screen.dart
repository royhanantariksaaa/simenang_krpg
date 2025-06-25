import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../controllers/classroom_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/cards/classroom_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/forms/krpg_search_bar.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../views/screens/classroom/classroom_detail_screen.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Defer the API call to after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadClassrooms();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _loadClassrooms() {
    final classroomController = context.read<ClassroomController>();
    classroomController.getClassrooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classrooms'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'My Classes'),
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
                _buildClassroomList('all'),
                _buildClassroomList('active'),
                _buildMyClassrooms(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(KRPGTheme.spacingMd),
      color: KRPGTheme.backgroundSecondary,
      child: Column(
        children: [
          KRPGSearchBar(
            hintText: 'Search classrooms...',
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
          _buildStatusFilter(),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Active', 'active'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Inactive', 'inactive'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Full', 'full'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? value : 'all';
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

  Widget _buildClassroomList(String status) {
    return Consumer<ClassroomController>(
      builder: (context, classroomController, child) {
        if (classroomController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (classroomController.error != null) {
          return _buildErrorState(classroomController);
        }

        final classrooms = classroomController.classrooms;
        if (classrooms.isEmpty) {
          return _buildEmptyState(status);
        }

        // Filter classrooms based on status (using studentCount for now)
        final filteredClassrooms = classrooms.where((classroom) {
          if (status == 'all') return true;
          if (status == 'active') return classroom.studentCount != null && classroom.studentCount! > 0;
          if (status == 'inactive') return classroom.studentCount == null || classroom.studentCount == 0;
          if (status == 'full') return classroom.studentCount != null && classroom.studentCount! >= 20; // Assuming max 20 students
          return true;
        }).toList();

        if (filteredClassrooms.isEmpty) {
          return _buildEmptyState(status);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await classroomController.getClassrooms();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            itemCount: filteredClassrooms.length,
            itemBuilder: (context, index) {
              final classroom = filteredClassrooms[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: KRPGTheme.spacingMd),
                child: ClassroomCard(
                  classroom: classroom,
                  onTap: () {
                    _showClassroomDetails(classroom);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyClassrooms() {
    return Consumer<ClassroomController>(
      builder: (context, classroomController, child) {
        if (classroomController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (classroomController.error != null) {
          return _buildErrorState(classroomController);
        }

        // For now, show all classrooms as "my classrooms"
        // TODO: Implement proper my classrooms filtering
        final classrooms = classroomController.classrooms;
        if (classrooms.isEmpty) {
          return _buildEmptyState('my');
        }

        return RefreshIndicator(
          onRefresh: () async {
            await classroomController.getClassrooms();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            itemCount: classrooms.length,
            itemBuilder: (context, index) {
              final classroom = classrooms[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: KRPGTheme.spacingMd),
                child: ClassroomCard(
                  classroom: classroom,
                  onTap: () {
                    _showClassroomDetails(classroom);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(ClassroomController classroomController) {
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
              'Failed to load classrooms',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              classroomController.error ?? 'Unknown error occurred',
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            KRPGButton(
              text: 'Retry',
              onPressed: () {
                classroomController.getClassrooms();
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
              Icons.class_outlined,
              size: 48,
              color: KRPGTheme.textMedium,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            Text(
              'No classrooms found',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              status == 'all'
                  ? 'No classrooms are available at the moment.'
                  : status == 'my'
                      ? 'You are not enrolled in any classrooms.'
                      : 'No $status classrooms found.',
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



  void _performSearch() {
    final classroomController = context.read<ClassroomController>();
    final searchTerm = _searchController.text.trim();
    
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    classroomController.getClassrooms(
      search: searchTerm.isNotEmpty ? searchTerm : null,
      status: _selectedStatus != 'all' ? _selectedStatus : null,
    );
    });
  }

  void _showClassroomDetails(dynamic classroom) {
    // Debug log the classroom object
    print('🔍 Navigating to classroom details with classroom: ${classroom.toString()}');
    print('🔍 Classroom ID: ${classroom.id}');
    print('🔍 Classroom Name: ${classroom.name}');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassroomDetailScreen(
          classroom: classroom,
        ),
      ),
    );
  }

  void _showClassroomStudents(String classroomId) {
    // TODO: Navigate to classroom students screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Students for classroom: $classroomId'),
      ),
    );
  }

  void _showCreateClassroomDialog() {
    // TODO: Implement create classroom dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create classroom functionality coming soon'),
      ),
    );
  }
} 