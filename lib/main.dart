import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/screens/showcase/component_showcase_screen.dart';
import 'views/screens/showcase/api_showcase_screen.dart';
import 'views/screens/auth/login_screen.dart';
import 'views/screens/home/home_screen.dart';
import 'views/screens/training/training_screen.dart';
import 'views/screens/competition/competition_screen.dart';
import 'views/screens/classroom/classroom_screen.dart';
import 'views/screens/athletes/athletes_screen.dart';
import 'views/screens/profile/profile_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/training_controller.dart';
import 'controllers/competition_controller.dart';
import 'controllers/classroom_controller.dart';
import 'controllers/athletes_controller.dart';
import 'controllers/membership_controller.dart';
import 'design_system/krpg_theme.dart';
import 'config/app_config.dart';
import 'components/ui/dummy_data_indicator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => TrainingController()),
        ChangeNotifierProvider(create: (_) => CompetitionController()),
        ChangeNotifierProvider(create: (_) => ClassroomController()),
        ChangeNotifierProvider(create: (_) => AthletesController()),
        ChangeNotifierProvider(create: (_) => MembershipController()),
      ],
      child: MaterialApp(
        title: 'SiMenang KRPG',
        theme: KRPGTheme.lightTheme,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final authController = context.read<AuthController>();
    
    // Initialize authentication (load stored token and validate)
    await authController.initialize();
    
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking authentication...'),
            ],
          ),
        ),
      );
    }

    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isAuthenticated) {
          return const MainNavigationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _hasShownUEQSDialog = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TrainingScreen(),
    const CompetitionScreen(),
    const ClassroomScreen(),
    const AthletesScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Show UEQ-S welcome dialog after build is complete
    if (AppConfig.isDummyDataForUEQSTest && !_hasShownUEQSDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showUEQSWelcomeDialog();
      });
    }
  }

  void _showUEQSWelcomeDialog() {
    if (_hasShownUEQSDialog) return;
    _hasShownUEQSDialog = true;
    DummyDataDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          // Show dummy data indicator in floating mode
          const DummyDataIndicator(isFloating: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: KRPGTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Competition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classroom',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Athlete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
