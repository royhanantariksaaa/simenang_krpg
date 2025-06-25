import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/training_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/cards/training_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/forms/krpg_search_bar.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';
import '../../../models/user_model.dart';
import '../../../views/screens/training/training_detail_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Defer the API call to after the build is complete to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTrainings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadTrainings() {
    final trainingController = context.read<TrainingController>();
    trainingController.getTrainings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
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
            Tab(text: 'Scheduled'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
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
                _buildTrainingList('all'),
                _buildTrainingList('scheduled'),
                _buildTrainingList('ongoing'),
                _buildTrainingList('completed'),
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
            hintText: 'Search trainings...',
            onChanged: (value) {
              _performSearch();
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
          _buildFilterChip('Scheduled', 'scheduled'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Ongoing', 'ongoing'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Completed', 'completed'),
          const SizedBox(width: KRPGTheme.spacingSm),
          _buildFilterChip('Cancelled', 'cancelled'),
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

  Widget _buildTrainingList(String status) {
    return Consumer<TrainingController>(
      builder: (context, trainingController, child) {
        if (trainingController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (trainingController.error != null) {
          return _buildErrorState(trainingController);
        }

        final trainings = trainingController.trainings;
        if (trainings.isEmpty) {
          return _buildEmptyState(status);
        }

        // Filter trainings based on status
        final filteredTrainings = trainings.where((training) {
          if (status == 'all') return true;
          return training.status.toString().toLowerCase() == status;
        }).toList();

        if (filteredTrainings.isEmpty) {
          return _buildEmptyState(status);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await trainingController.getTrainings();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            itemCount: filteredTrainings.length,
            itemBuilder: (context, index) {
              final training = filteredTrainings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: KRPGTheme.spacingMd),
                child: TrainingCard(
                  training: training,
                  onTap: () {
                    _showTrainingDetails(training);
                  },
                  onJoin: () {
                    _startTraining(training.idTraining);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(TrainingController trainingController) {
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
              'Failed to load trainings',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              trainingController.error ?? 'Unknown error occurred',
              style: KRPGTextStyles.bodyMedium.copyWith(
                color: KRPGTheme.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            KRPGButton(
              text: 'Retry',
              onPressed: () {
                trainingController.getTrainings();
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
              Icons.fitness_center_outlined,
              size: 48,
              color: KRPGTheme.textMedium,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            Text(
              'No trainings found',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingSm),
            Text(
              status == 'all'
                  ? 'No trainings are available at the moment.'
                  : 'No $status trainings found.',
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
    final trainingController = context.read<TrainingController>();
    final searchTerm = _searchController.text.trim();
    
    trainingController.getTrainings(
      search: searchTerm.isNotEmpty ? searchTerm : null,
      status: _selectedStatus != 'all' ? _selectedStatus : null,
    );
  }

  void _showTrainingDetails(dynamic training) {
    // Debug logging for UEQ-S testing
    debugPrint('🔍 [Training Navigation] Clicked training: ${training.title} (ID: ${training.idTraining})');
    debugPrint('🔍 [Training Navigation] Training data: ${training.toString()}');
    
    // Ensure we have valid training data before navigation
    if (training == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Training data not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainingDetailScreen(
            training: training,
          ),
        ),
      ).then((_) {
        // Refresh the training list when returning from detail screen
        _loadTrainings();
      });
    } catch (e) {
      debugPrint('❌ [Training Navigation] Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to open training details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startTraining(String trainingId) {
    final trainingController = context.read<TrainingController>();
    trainingController.startTraining(trainingId).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Training started successfully!'),
            backgroundColor: KRPGTheme.successColor,
          ),
        );
        // Refresh the list
        trainingController.getTrainings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(trainingController.error ?? 'Failed to start training'),
            backgroundColor: KRPGTheme.dangerColor,
          ),
        );
      }
    });
  }

  void _showCreateTrainingDialog() {
    // TODO: Implement create training dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create training functionality coming soon'),
      ),
    );
  }
} 