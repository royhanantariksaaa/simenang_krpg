import 'package:flutter/material.dart';
import 'package:simenang_krpg/views/screens/auth/login_screen.dart';
import '../views/screens/showcase/component_showcase_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String componentShowcase = '/component-showcase';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case componentShowcase:
        return MaterialPageRoute(
          builder: (_) => const ComponentShowcaseScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ComponentShowcaseScreen(),
          settings: settings,
        );
    }
  }
} 