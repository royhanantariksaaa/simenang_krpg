import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load home data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: KRPGTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<HomeController, AuthController>(
        builder: (context, homeController, authController, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await homeController.getHomeData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(KRPGTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(authController),
                  const SizedBox(height: KRPGTheme.spacingLg),
                  _buildQuickStatsSection(homeController),
                  const SizedBox(height: KRPGTheme.spacingLg),
                  _buildRecentActivitiesSection(homeController),
                  const SizedBox(height: KRPGTheme.spacingLg),
                  _buildUpcomingTrainingsSection(homeController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(AuthController authController) {
    return KRPGCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: KRPGTheme.primaryColor,
                ),
              ),
              const SizedBox(width: KRPGTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: KRPGTextStyles.heading6.copyWith(
                        color: KRPGTheme.textMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authController.currentUser?.username ?? 'User',
                      style: KRPGTextStyles.heading4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    KRPGBadge.info(
                      text: authController.currentUser?.role.toString().toUpperCase() ?? 'USER',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection(HomeController homeController) {
    if (homeController.isLoading) {
      return const KRPGCard(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final homeData = homeController.homeData;
    if (homeData == null) {
      return KRPGCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: KRPGTextStyles.heading5,
            ),
            const SizedBox(height: KRPGTheme.spacingMd),
            KRPGButton(
              text: 'Retry',
              onPressed: () => homeController.getHomeData(),
              type: KRPGButtonType.outlined,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: KRPGTextStyles.heading5,
        ),
        const SizedBox(height: KRPGTheme.spacingMd),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Training Sessions',
                homeData['total_trainings']?.toString() ?? '0',
                Icons.fitness_center,
                KRPGTheme.neutralMedium,
              ),
            ),
            const SizedBox(width: KRPGTheme.spacingMd),
            Expanded(
              child: _buildStatCard(
                'Competitions',
                homeData['total_competitions']?.toString() ?? '0',
                Icons.emoji_events,
                KRPGTheme.neutralMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: KRPGTheme.spacingMd),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Classrooms',
                homeData['total_classrooms']?.toString() ?? '0',
                Icons.class_,
                KRPGTheme.neutralMedium,
              ),
            ),
            const SizedBox(width: KRPGTheme.spacingMd),
            Expanded(
              child: _buildStatCard(
                'Athletes',
                homeData['total_athletes']?.toString() ?? '0',
                Icons.people,
                KRPGTheme.neutralMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return KRPGCard(
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: KRPGTheme.spacingSm),
          Text(
            value,
            style: KRPGTextStyles.heading4.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: KRPGTextStyles.bodyMedium.copyWith(
              color: KRPGTheme.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection(HomeController homeController) {
    final homeData = homeController.homeData;
    final recentActivities = homeData?['recent_activities'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: KRPGTextStyles.heading5,
        ),
        const SizedBox(height: KRPGTheme.spacingMd),
        if (recentActivities.isEmpty)
          KRPGCard(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: KRPGTheme.textMedium,
                  ),
                  const SizedBox(height: KRPGTheme.spacingMd),
                  Text(
                    'No recent activities',
                    style: KRPGTextStyles.bodyLarge.copyWith(
                      color: KRPGTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentActivities.length > 5 ? 5 : recentActivities.length,
            itemBuilder: (context, index) {
              final activity = recentActivities[index];
              return KRPGCard(
                margin: EdgeInsets.only(
                  bottom: index < (recentActivities.length > 5 ? 5 : recentActivities.length) - 1
                      ? KRPGTheme.spacingSm
                      : 0,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: KRPGTheme.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.notifications,
                      color: KRPGTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    activity['title'] ?? 'Activity',
                    style: KRPGTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    activity['description'] ?? 'No description',
                    style: KRPGTextStyles.bodyMedium.copyWith(
                      color: KRPGTheme.textMedium,
                    ),
                  ),
                  trailing: Text(
                    activity['time'] ?? 'Now',
                    style: KRPGTextStyles.caption.copyWith(
                      color: KRPGTheme.textMedium,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildUpcomingTrainingsSection(HomeController homeController) {
    final homeData = homeController.homeData;
    final upcomingTrainings = homeData?['upcoming_trainings'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Trainings',
          style: KRPGTextStyles.heading5,
        ),
        const SizedBox(height: KRPGTheme.spacingMd),
        if (upcomingTrainings.isEmpty)
          KRPGCard(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center_outlined,
                    size: 48,
                    color: KRPGTheme.textMedium,
                  ),
                  const SizedBox(height: KRPGTheme.spacingMd),
                  Text(
                    'No upcoming trainings',
                    style: KRPGTextStyles.bodyLarge.copyWith(
                      color: KRPGTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingTrainings.length > 3 ? 3 : upcomingTrainings.length,
            itemBuilder: (context, index) {
              final training = upcomingTrainings[index];
              return KRPGCard(
                margin: EdgeInsets.only(
                  bottom: index < (upcomingTrainings.length > 3 ? 3 : upcomingTrainings.length) - 1
                      ? KRPGTheme.spacingSm
                      : 0,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: KRPGTheme.successColor.withOpacity(0.1),
                    child: Icon(
                      Icons.fitness_center,
                      color: KRPGTheme.successColor,
                    ),
                  ),
                  title: Text(
                    training['title'] ?? 'Training',
                    style: KRPGTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        training['datetime'] ?? 'No date',
                        style: KRPGTextStyles.bodyMedium.copyWith(
                          color: KRPGTheme.textMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      KRPGBadge(
                        text: training['status'] ?? 'Scheduled',
                        backgroundColor: _getStatusColor(training['status']).withOpacity(0.1),
                        textColor: _getStatusColor(training['status']),
                        fontSize: KRPGTheme.fontSizeXs,
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: KRPGTheme.textMedium,
                    size: 16,
                  ),
                  onTap: () {
                    // TODO: Navigate to training details
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Training details for: ${training['title']}'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return KRPGTheme.infoColor;
      case 'ongoing':
        return KRPGTheme.successColor;
      case 'completed':
        return KRPGTheme.neutralMedium;
      case 'cancelled':
        return KRPGTheme.dangerColor;
      default:
        return KRPGTheme.textMedium;
    }
  }


} 