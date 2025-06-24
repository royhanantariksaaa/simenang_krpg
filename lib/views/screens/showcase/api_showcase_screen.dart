import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/training_controller.dart';
import '../../../controllers/competition_controller.dart';
import '../../../controllers/classroom_controller.dart';
import '../../../controllers/athletes_controller.dart';
import '../../../controllers/membership_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../components/layout/krpg_scaffold.dart';
import '../../../components/buttons/krpg_button.dart';
import '../../../components/cards/krpg_card.dart';
import '../../../components/ui/krpg_badge.dart';
import '../../../design_system/krpg_theme.dart';
import '../../../design_system/krpg_text_styles.dart';

class ApiShowcaseScreen extends StatefulWidget {
  const ApiShowcaseScreen({super.key});

  @override
  State<ApiShowcaseScreen> createState() => _ApiShowcaseScreenState();
}

class _ApiShowcaseScreenState extends State<ApiShowcaseScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _logController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _logController.text = '🔗 API Showcase Ready\n';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _logController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    setState(() {
      _logController.text += '${DateTime.now().toString().substring(11, 19)}: $message\n';
    });
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearLog() {
    setState(() {
      _logController.text = '🔗 API Showcase Ready\n';
    });
  }

  @override
  Widget build(BuildContext context) {
    return KRPGScaffold(
      title: 'API Showcase',
      appBarActions: [
        KRPGButton(
          text: 'Clear Log',
          onPressed: _clearLog,
          type: KRPGButtonType.outlined,
          size: KRPGButtonSize.small,
        ),
      ],
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: KRPGTheme.backgroundSecondary,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: KRPGTheme.primaryColor,
              labelColor: KRPGTheme.primaryColor,
              unselectedLabelColor: KRPGTheme.textMedium,
              tabs: const [
                Tab(text: 'Auth'),
                Tab(text: 'Home'),
                Tab(text: 'Training'),
                Tab(text: 'Competition'),
                Tab(text: 'Classroom'),
                Tab(text: 'Athletes'),
                Tab(text: 'Membership'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAuthTab(),
                _buildHomeTab(),
                _buildTrainingTab(),
                _buildCompetitionTab(),
                _buildClassroomTab(),
                _buildAthletesTab(),
                _buildMembershipTab(),
              ],
            ),
          ),
          
          // Log Section
          Container(
            height: 200,
            padding: const EdgeInsets.all(KRPGTheme.spacingMd),
            decoration: BoxDecoration(
              color: KRPGTheme.backgroundSecondary,
              border: Border(
                top: BorderSide(color: KRPGTheme.borderColor),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terminal, size: 16),
                    const SizedBox(width: KRPGTheme.spacingXs),
                    Text(
                      'API Log',
                      style: KRPGTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KRPGTheme.spacingSm),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(KRPGTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: KRPGTheme.backgroundPrimary,
                      borderRadius: BorderRadius.circular(KRPGTheme.radiusXs),
                      border: Border.all(color: KRPGTheme.borderColor),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: TextField(
                        controller: _logController,
                        maxLines: null,
                        readOnly: true,
                        style: KRPGTextStyles.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthTab() {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Authentication APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Login Section
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.login, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Login',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'POST /login',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Test Login',
                      onPressed: () async {
                        _addLog('🔐 Testing login...');
                        final success = await authController.login('test@example.com', 'password123');
                        if (success) {
                          _addLog('✅ Login successful');
                        } else {
                          _addLog('❌ Login failed: ${authController.error}');
                        }
                      },
                      isLoading: authController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Register Section
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_add, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Register',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'POST /register',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Test Register',
                      onPressed: () async {
                        _addLog('🔐 Testing registration...');
                        final success = await authController.register(
                          username: 'testuser',
                          email: 'test@example.com',
                          password: 'password123',
                          role: 'athlete',
                        );
                        if (success) {
                          _addLog('✅ Registration successful');
                        } else {
                          _addLog('❌ Registration failed: ${authController.error}');
                        }
                      },
                      isLoading: authController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Profile Section
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Profile Management',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.info(
                          text: 'GET/PUT /profile',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    Row(
                      children: [
                        Expanded(
                          child: KRPGButton(
                            text: 'Get Profile',
                            onPressed: () async {
                              _addLog('👤 Getting profile...');
                              final profile = await authController.getProfileDetails();
                              if (profile != null) {
                                _addLog('✅ Profile retrieved');
                              } else {
                                _addLog('❌ Failed to get profile: ${authController.error}');
                              }
                            },
                            isLoading: authController.isLoading,
                          ),
                        ),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Expanded(
                          child: KRPGButton(
                            text: 'Update Profile',
                            onPressed: () async {
                              _addLog('👤 Updating profile...');
                              final success = await authController.updateProfile(
                                name: 'Updated Name',
                                phone: '+1234567890',
                              );
                              if (success) {
                                _addLog('✅ Profile updated');
                              } else {
                                _addLog('❌ Failed to update profile: ${authController.error}');
                              }
                            },
                            isLoading: authController.isLoading,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Logout Section
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.logout, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Logout',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.warning(
                          text: 'POST /logout',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Test Logout',
                      onPressed: () async {
                        _addLog('🔐 Testing logout...');
                        final success = await authController.logout();
                        if (success) {
                          _addLog('✅ Logout successful');
                        } else {
                          _addLog('❌ Logout failed: ${authController.error}');
                        }
                      },
                      isLoading: authController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeTab() {
    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Home Dashboard APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.home, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Dashboard Data',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'GET /home',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Dashboard Data',
                      onPressed: () async {
                        _addLog('🏠 Getting dashboard data...');
                        final data = await homeController.getHomeData();
                        if (data != null) {
                          _addLog('✅ Dashboard data retrieved');
                        } else {
                          _addLog('❌ Failed to get dashboard data: ${homeController.error}');
                        }
                      },
                      isLoading: homeController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrainingTab() {
    return Consumer<TrainingController>(
      builder: (context, trainingController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Training APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Get Trainings
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fitness_center, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Get Trainings',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'GET /training',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Trainings',
                      onPressed: () async {
                        _addLog('🏊 Getting trainings...');
                        final trainings = await trainingController.getTrainings();
                        if (trainings.isNotEmpty) {
                          _addLog('✅ Retrieved ${trainings.length} trainings');
                        } else {
                          _addLog('❌ Failed to get trainings: ${trainingController.error}');
                        }
                      },
                      isLoading: trainingController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Training Details
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Training Details',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.info(
                          text: 'GET /training/{id}',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Training Details',
                      onPressed: () async {
                        _addLog('🏊 Getting training details...');
                        final training = await trainingController.getTrainingDetails('1');
                        if (training != null) {
                          _addLog('✅ Training details retrieved');
                        } else {
                          _addLog('❌ Failed to get training details: ${trainingController.error}');
                        }
                      },
                      isLoading: trainingController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Start Training
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.play_arrow, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Start Training',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.warning(
                          text: 'POST /training/{id}/start',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Start Training',
                      onPressed: () async {
                        _addLog('🏊 Starting training...');
                        final result = await trainingController.startTraining('1');
                        if (result != null) {
                          _addLog('✅ Training started');
                        } else {
                          _addLog('❌ Failed to start training: ${trainingController.error}');
                        }
                      },
                      isLoading: trainingController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompetitionTab() {
    return Consumer<CompetitionController>(
      builder: (context, competitionController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Competition APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Get Competitions
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Get Competitions',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'GET /competitions',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Competitions',
                      onPressed: () async {
                        _addLog('🏆 Getting competitions...');
                        final competitions = await competitionController.getCompetitions();
                        if (competitions.isNotEmpty) {
                          _addLog('✅ Retrieved ${competitions.length} competitions');
                        } else {
                          _addLog('❌ Failed to get competitions: ${competitionController.error}');
                        }
                      },
                      isLoading: competitionController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Competition Details
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Competition Details',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.info(
                          text: 'GET /competitions/{id}',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Competition Details',
                      onPressed: () async {
                        _addLog('🏆 Getting competition details...');
                        final competition = await competitionController.getCompetitionDetails('1');
                        if (competition != null) {
                          _addLog('✅ Competition details retrieved');
                        } else {
                          _addLog('❌ Failed to get competition details: ${competitionController.error}');
                        }
                      },
                      isLoading: competitionController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Register for Competition
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.how_to_reg, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Register for Competition',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.warning(
                          text: 'POST /competitions/{id}/register',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Register for Competition',
                      onPressed: () async {
                        _addLog('🏆 Registering for competition...');
                        final result = await competitionController.registerForCompetition(
                          competitionId: '1',
                          note: 'Test registration',
                        );
                        if (result != null) {
                          _addLog('✅ Registered for competition');
                        } else {
                          _addLog('❌ Failed to register: ${competitionController.error}');
                        }
                      },
                      isLoading: competitionController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassroomTab() {
    return Consumer<ClassroomController>(
      builder: (context, classroomController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Classroom APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Get Classrooms
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Get Classrooms',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'GET /classrooms',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Classrooms',
                      onPressed: () async {
                        _addLog('🏫 Getting classrooms...');
                        final classrooms = await classroomController.getClassrooms();
                        if (classrooms.isNotEmpty) {
                          _addLog('✅ Retrieved ${classrooms.length} classrooms');
                        } else {
                          _addLog('❌ Failed to get classrooms: ${classroomController.error}');
                        }
                      },
                      isLoading: classroomController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Classroom Details
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Classroom Details',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.info(
                          text: 'GET /classrooms/{id}',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Classroom Details',
                      onPressed: () async {
                        _addLog('🏫 Getting classroom details...');
                        final classroom = await classroomController.getClassroomDetails('1');
                        if (classroom != null) {
                          _addLog('✅ Classroom details retrieved');
                        } else {
                          _addLog('❌ Failed to get classroom details: ${classroomController.error}');
                        }
                      },
                      isLoading: classroomController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAthletesTab() {
    return Consumer<AthletesController>(
      builder: (context, athletesController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Athletes APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Get Athletes
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Get Athletes',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'GET /athletes',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Athletes',
                      onPressed: () async {
                        _addLog('🏃 Getting athletes...');
                        final athletes = await athletesController.getAthletes();
                        if (athletes != null && athletes.isNotEmpty) {
                          _addLog('✅ Retrieved ${athletes.length} athletes');
                        } else {
                          _addLog('❌ Failed to get athletes: ${athletesController.error}');
                        }
                      },
                      isLoading: athletesController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Athlete Details
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Athlete Details',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.info(
                          text: 'GET /athletes/{id}',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Athlete Details',
                      onPressed: () async {
                        _addLog('🏃 Getting athlete details...');
                        final athlete = await athletesController.getAthleteDetail('1');
                        if (athlete != null) {
                          _addLog('✅ Athlete details retrieved');
                        } else {
                          _addLog('❌ Failed to get athlete details: ${athletesController.error}');
                        }
                      },
                      isLoading: athletesController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembershipTab() {
    return Consumer<MembershipController>(
      builder: (context, membershipController, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(KRPGTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Membership APIs',
                style: KRPGTextStyles.heading5,
              ),
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Get Membership Status
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.card_membership, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Membership Status',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.success(
                          text: 'GET /membership/status',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Membership Status',
                      onPressed: () async {
                        _addLog('💳 Getting membership status...');
                        final status = await membershipController.getMembershipStatus();
                        if (status != null) {
                          _addLog('✅ Membership status retrieved');
                        } else {
                          _addLog('❌ Failed to get membership status: ${membershipController.error}');
                        }
                      },
                      isLoading: membershipController.isLoading,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KRPGTheme.spacingMd),
              
              // Payment History
              KRPGCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.history, color: KRPGTheme.primaryColor),
                        const SizedBox(width: KRPGTheme.spacingSm),
                        Text(
                          'Payment History',
                          style: KRPGTextStyles.heading6,
                        ),
                        const Spacer(),
                        KRPGBadge.info(
                          text: 'GET /membership/payment-history',
                        ),
                      ],
                    ),
                    const SizedBox(height: KRPGTheme.spacingMd),
                    KRPGButton(
                      text: 'Get Payment History',
                      onPressed: () async {
                        _addLog('💳 Getting payment history...');
                        final history = await membershipController.getPaymentHistory();
                        if (history != null) {
                          _addLog('✅ Payment history retrieved');
                        } else {
                          _addLog('❌ Failed to get payment history: ${membershipController.error}');
                        }
                      },
                      isLoading: membershipController.isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 