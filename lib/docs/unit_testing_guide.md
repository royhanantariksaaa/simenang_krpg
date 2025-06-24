# KRPG Flutter App - Unit Testing Guide

## Overview
This document provides a comprehensive guide for implementing unit tests for the KRPG Flutter application. The testing strategy covers all major components including controllers, services, models, and UI components.

## Testing Structure

### 1. Test Directory Structure
```
test/
├── unit/
│   ├── controllers/
│   │   ├── auth_controller_test.dart
│   │   ├── home_controller_test.dart
│   │   ├── training_controller_test.dart
│   │   ├── competition_controller_test.dart
│   │   ├── classroom_controller_test.dart
│   │   ├── athletes_controller_test.dart
│   │   └── membership_controller_test.dart
│   ├── services/
│   │   └── api_service_test.dart
│   ├── models/
│   │   ├── user_model_test.dart
│   │   ├── training_model_test.dart
│   │   ├── competition_model_test.dart
│   │   ├── classroom_model_test.dart
│   │   └── athlete_model_test.dart
│   └── utils/
│       └── helpers_test.dart
├── widget/
│   ├── screens/
│   │   ├── login_screen_test.dart
│   │   ├── home_screen_test.dart
│   │   ├── training_screen_test.dart
│   │   ├── competition_screen_test.dart
│   │   ├── classroom_screen_test.dart
│   │   ├── athletes_screen_test.dart
│   │   └── profile_screen_test.dart
│   └── components/
│       ├── krpg_button_test.dart
│       ├── krpg_card_test.dart
│       ├── krpg_search_bar_test.dart
│       └── krpg_badge_test.dart
└── integration/
    └── app_test.dart
```

## Dependencies

### Required Testing Packages
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.8
  http_mock_adapter: ^0.6.1
  provider: ^6.1.1
  test: ^1.24.9
```

## Unit Tests

### 1. Controller Tests

#### AuthController Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:krpg_app/controllers/auth_controller.dart';
import 'package:krpg_app/services/api_service.dart';
import 'auth_controller_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('AuthController Tests', () {
    late AuthController authController;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      authController = AuthController();
    });

    group('Login Tests', () {
      test('should login successfully with valid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        
        when(mockApiService.post('login', body: {
          'login': email,
          'password': password,
        })).thenAnswer((_) async => {
          'success': true,
          'message': 'Login berhasil',
          'data': {
            'role': 'coach',
            'token': 'test_token_123'
          }
        });

        // Act
        final result = await authController.login(email, password);

        // Assert
        expect(result, isTrue);
        expect(authController.isAuthenticated, isTrue);
        expect(authController.currentUser?.role, UserRole.coach);
        expect(authController.token, 'test_token_123');
      });

      test('should fail login with invalid credentials', () async {
        // Arrange
        const email = 'invalid@example.com';
        const password = 'wrongpassword';
        
        when(mockApiService.post('login', body: {
          'login': email,
          'password': password,
        })).thenAnswer((_) async => {
          'success': false,
          'message': 'Invalid credentials',
          'data': null
        });

        // Act
        final result = await authController.login(email, password);

        // Assert
        expect(result, isFalse);
        expect(authController.isAuthenticated, isFalse);
        expect(authController.error, 'Invalid credentials');
      });

      test('should handle network errors during login', () async {
        // Arrange
        when(mockApiService.post('login', body: anyNamed('body')))
            .thenThrow(Exception('Network error'));

        // Act
        final result = await authController.login('test@example.com', 'password');

        // Assert
        expect(result, isFalse);
        expect(authController.error, contains('Network error'));
      });
    });

    group('Token Validation Tests', () {
      test('should validate existing token successfully', () async {
        // Arrange
        authController.token = 'valid_token';
        
        when(mockApiService.get('check-token'))
            .thenAnswer((_) async => {
          'success': true,
          'message': 'Token is valid',
          'data': {
            'role': 'coach',
            'token': 'valid_token'
          }
        });

        // Act
        final result = await authController.checkToken();

        // Assert
        expect(result, isTrue);
        expect(authController.isAuthenticated, isTrue);
      });

      test('should handle invalid token', () async {
        // Arrange
        authController.token = 'invalid_token';
        
        when(mockApiService.get('check-token'))
            .thenAnswer((_) async => {
          'success': false,
          'message': 'Token is invalid',
          'data': null
        });

        // Act
        final result = await authController.checkToken();

        // Assert
        expect(result, isFalse);
        expect(authController.isAuthenticated, isFalse);
        expect(authController.token, isNull);
      });
    });

    group('Logout Tests', () {
      test('should logout successfully', () async {
        // Arrange
        authController.token = 'test_token';
        authController.currentUser = User(
          idAccount: '1',
          username: 'testuser',
          email: 'test@example.com',
          role: UserRole.coach,
        );
        
        when(mockApiService.post('logout'))
            .thenAnswer((_) async => {
          'success': true,
          'message': 'Logged out successfully',
          'data': null
        });

        // Act
        await authController.logout();

        // Assert
        expect(authController.isAuthenticated, isFalse);
        expect(authController.token, isNull);
        expect(authController.currentUser, isNull);
      });
    });
  });
}
```

#### HomeController Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:krpg_app/controllers/home_controller.dart';
import 'package:krpg_app/services/api_service.dart';
import 'home_controller_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('HomeController Tests', () {
    late HomeController homeController;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      homeController = HomeController();
    });

    group('Get Home Data Tests', () {
      test('should load home data successfully', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'message': 'Dashboard data retrieved',
          'data': {
            'total_trainings': 15,
            'total_competitions': 8,
            'total_classrooms': 5,
            'total_athletes': 25,
            'recent_activities': [
              {
                'title': 'Training Session Started',
                'description': 'Coach started training session #123',
                'time': '2 hours ago'
              }
            ],
            'upcoming_trainings': [
              {
                'id': 1,
                'title': 'Morning Training',
                'datetime': '2025-06-25 07:00:00',
                'status': 'scheduled'
              }
            ]
          }
        };

        when(mockApiService.get('home'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await homeController.getHomeData();

        // Assert
        expect(result, isNotNull);
        expect(homeController.homeData, isNotNull);
        expect(homeController.homeData!['total_trainings'], 15);
        expect(homeController.homeData!['total_competitions'], 8);
        expect(homeController.isLoading, isFalse);
        expect(homeController.error, isNull);
      });

      test('should handle API errors', () async {
        // Arrange
        when(mockApiService.get('home'))
            .thenAnswer((_) async => {
          'success': false,
          'message': 'Failed to load dashboard data',
          'data': null
        });

        // Act
        final result = await homeController.getHomeData();

        // Assert
        expect(result, isNull);
        expect(homeController.error, 'Failed to load dashboard data');
        expect(homeController.isLoading, isFalse);
      });
    });
  });
}
```

### 2. Service Tests

#### ApiService Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:krpg_app/services/api_service.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;
    late HttpMockAdapter httpMockAdapter;

    setUp(() {
      apiService = ApiService();
      httpMockAdapter = HttpMockAdapter();
      httpMockAdapter.onPost('http://10.0.2.2:8000/api/login').reply(
        200,
        {
          'status': true,
          'message': 'Login berhasil',
          'data': {
            'role': 'coach',
            'token': 'test_token_123'
          }
        },
      );
    });

    group('POST Request Tests', () {
      test('should make successful POST request', () async {
        // Arrange
        final body = {
          'login': 'test@example.com',
          'password': 'password123'
        };

        // Act
        final response = await apiService.post('login', body: body);

        // Assert
        expect(response['success'], isTrue);
        expect(response['message'], 'Login berhasil');
        expect(response['data']['role'], 'coach');
        expect(response['data']['token'], 'test_token_123');
      });

      test('should handle network errors', () async {
        // Arrange
        httpMockAdapter.onPost('http://10.0.2.2:8000/api/login').throwsA(
          SocketException('Connection failed'),
        );

        // Act & Assert
        expect(
          () => apiService.post('login', body: {'test': 'data'}),
          throwsA(isA<SocketException>()),
        );
      });
    });

    group('GET Request Tests', () {
      test('should make successful GET request', () async {
        // Arrange
        httpMockAdapter.onGet('http://10.0.2.2:8000/api/home').reply(
          200,
          {
            'status': true,
            'message': 'Dashboard data retrieved',
            'data': {
              'total_trainings': 15,
              'total_competitions': 8
            }
          },
        );

        // Act
        final response = await apiService.get('home');

        // Assert
        expect(response['success'], isTrue);
        expect(response['data']['total_trainings'], 15);
      });
    });

    group('Authentication Tests', () {
      test('should include authorization header when token is set', () async {
        // Arrange
        apiService.setToken('test_token');
        
        httpMockAdapter.onGet('http://10.0.2.2:8000/api/profile').reply(
          200,
          {
            'status': true,
            'message': 'Profile retrieved',
            'data': {'id': 1, 'name': 'Test User'}
          },
        );

        // Act
        final response = await apiService.get('profile');

        // Assert
        expect(response['success'], isTrue);
        // Verify that the request included the Authorization header
        expect(httpMockAdapter.history.first.headers['Authorization'], 'Bearer test_token');
      });
    });
  });
}
```

### 3. Model Tests

#### User Model Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:krpg_app/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('should create User from JSON', () {
      // Arrange
      final json = {
        'id_account': '1',
        'username': 'testuser',
        'email': 'test@example.com',
        'role': 'coach',
        'status': '1',
        'profile': {
          'id_profile': '1',
          'name': 'Test User',
          'phone_number': '+628123456789',
          'address': 'Test Address',
          'birth_date': '1990-01-01',
          'gender': 'M'
        }
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.idAccount, '1');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.role, UserRole.coach);
      expect(user.status, UserStatus.active);
      expect(user.profile?.name, 'Test User');
      expect(user.profile?.phoneNumber, '+628123456789');
    });

    test('should convert User to JSON', () {
      // Arrange
      final user = User(
        idAccount: '1',
        username: 'testuser',
        email: 'test@example.com',
        role: UserRole.coach,
        profile: Profile(
          idProfile: '1',
          idAccount: '1',
          name: 'Test User',
          phoneNumber: '+628123456789',
        ),
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id_account'], '1');
      expect(json['username'], 'testuser');
      expect(json['email'], 'test@example.com');
      expect(json['role'], 'coach');
      expect(json['profile']['name'], 'Test User');
    });

    test('should handle missing optional fields', () {
      // Arrange
      final json = {
        'id_account': '1',
        'username': 'testuser',
        'email': 'test@example.com',
        'role': 'athlete',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.profile, isNull);
      expect(user.role, UserRole.athlete);
    });

    test('should copy user with new values', () {
      // Arrange
      final originalUser = User(
        idAccount: '1',
        username: 'testuser',
        email: 'test@example.com',
        role: UserRole.coach,
      );

      // Act
      final copiedUser = originalUser.copyWith(
        username: 'newuser',
        role: UserRole.leader,
      );

      // Assert
      expect(copiedUser.idAccount, '1');
      expect(copiedUser.username, 'newuser');
      expect(copiedUser.email, 'test@example.com');
      expect(copiedUser.role, UserRole.leader);
    });
  });
}
```

## Widget Tests

### 1. Screen Tests

#### LoginScreen Test Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:krpg_app/views/screens/login_screen.dart';
import 'package:krpg_app/controllers/auth_controller.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthController])
void main() {
  group('LoginScreen Tests', () {
    late MockAuthController mockAuthController;

    setUp(() {
      mockAuthController = MockAuthController();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthController>.value(
          value: mockAuthController,
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('should display login form', (WidgetTester tester) async {
      // Arrange
      when(mockAuthController.isLoading).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Username or Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show loading indicator when logging in', (WidgetTester tester) async {
      // Arrange
      when(mockAuthController.isLoading).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call login when form is submitted', (WidgetTester tester) async {
      // Arrange
      when(mockAuthController.isLoading).thenReturn(false);
      when(mockAuthController.login(any, any)).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(createTestWidget());
      
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockAuthController.login('test@example.com', 'password123')).called(1);
    });

    testWidgets('should show error message when login fails', (WidgetTester tester) async {
      // Arrange
      when(mockAuthController.isLoading).thenReturn(false);
      when(mockAuthController.error).thenReturn('Invalid credentials');
      when(mockAuthController.login(any, any)).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createTestWidget());
      
      await tester.enterText(find.byType(TextFormField).first, 'invalid@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

### 2. Component Tests

#### KRPGButton Test Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krpg_app/components/buttons/krpg_button.dart';

void main() {
  group('KRPGButton Tests', () {
    testWidgets('should display button with text', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KRPGButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KRPGButton(
              text: 'Test Button',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
    });

    testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KRPGButton(
              text: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Button'));
      await tester.pump();

      // Assert
      expect(wasPressed, isFalse);
    });

    testWidgets('should display icon when provided', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KRPGButton(
              text: 'Test Button',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should apply different button types', (WidgetTester tester) async {
      // Test outlined button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KRPGButton(
              text: 'Outlined Button',
              type: KRPGButtonType.outlined,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outlined Button'), findsOneWidget);
    });
  });
}
```

## Integration Tests

### App Integration Test Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krpg_app/main.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should show login screen when not authenticated', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MainApp());

      // Assert
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Username or Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should navigate to home screen after successful login', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MainApp());

      // Act - Simulate login
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should navigate between tabs', (WidgetTester tester) async {
      // Arrange - Start with authenticated user
      await tester.pumpWidget(const MainApp());
      // ... login steps ...

      // Act - Navigate to Training tab
      await tester.tap(find.text('Training'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Training'), findsOneWidget);

      // Act - Navigate to Competition tab
      await tester.tap(find.text('Competition'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Competitions'), findsOneWidget);
    });
  });
}
```

## Test Utilities

### Test Helpers
```dart
// test/utils/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krpg_app/controllers/auth_controller.dart';
import 'package:krpg_app/controllers/home_controller.dart';

class TestHelpers {
  static Widget createTestApp({
    required Widget child,
    List<ChangeNotifierProvider> providers = const [],
  }) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(
            create: (_) => AuthController(),
          ),
          ChangeNotifierProvider<HomeController>(
            create: (_) => HomeController(),
          ),
          ...providers,
        ],
        child: child,
      ),
    );
  }

  static Map<String, dynamic> createMockUser({
    String id = '1',
    String username = 'testuser',
    String email = 'test@example.com',
    String role = 'coach',
  }) {
    return {
      'id_account': id,
      'username': username,
      'email': email,
      'role': role,
      'profile': {
        'id_profile': id,
        'name': 'Test User',
        'phone_number': '+628123456789',
      }
    };
  }

  static Map<String, dynamic> createMockHomeData() {
    return {
      'total_trainings': 15,
      'total_competitions': 8,
      'total_classrooms': 5,
      'total_athletes': 25,
      'recent_activities': [
        {
          'title': 'Training Session Started',
          'description': 'Coach started training session #123',
          'time': '2 hours ago'
        }
      ],
      'upcoming_trainings': [
        {
          'id': 1,
          'title': 'Morning Training',
          'datetime': '2025-06-25 07:00:00',
          'status': 'scheduled'
        }
      ]
    };
  }
}
```

## Running Tests

### 1. Run All Tests
```bash
flutter test
```

### 2. Run Specific Test File
```bash
flutter test test/unit/controllers/auth_controller_test.dart
```

### 3. Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 4. Run Tests in Watch Mode
```bash
flutter test --watch
```

### 5. Generate Mock Files
```bash
flutter packages pub run build_runner build
```

## Test Coverage Goals

### Minimum Coverage Requirements
- **Controllers**: 90%
- **Services**: 95%
- **Models**: 100%
- **Widgets**: 80%
- **Overall**: 85%

### Coverage Categories
1. **Unit Tests**: Test individual functions and methods
2. **Widget Tests**: Test UI components in isolation
3. **Integration Tests**: Test app workflows and navigation
4. **Golden Tests**: Test visual appearance (if needed)

## Best Practices

### 1. Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### 2. Mocking
- Mock external dependencies (API, database)
- Use `@GenerateMocks` for complex mocks
- Keep mocks simple and focused

### 3. Test Data
- Use factory methods for test data
- Create reusable test helpers
- Use realistic test data

### 4. Assertions
- Test one thing per test
- Use specific assertions
- Test both success and failure cases

### 5. Performance
- Keep tests fast and focused
- Avoid unnecessary setup/teardown
- Use `setUp()` and `tearDown()` efficiently

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter packages pub run build_runner build
      - run: flutter test
```

## Troubleshooting

### Common Issues
1. **Mock Generation**: Run `flutter packages pub run build_runner build`
2. **Provider Errors**: Ensure proper provider setup in tests
3. **Async Tests**: Use `await tester.pumpAndSettle()` for async operations
4. **Network Tests**: Use `http_mock_adapter` for API testing

### Debug Tips
- Use `debugPrint()` in tests for debugging
- Check test output for detailed error messages
- Use `tester.pump()` and `tester.pumpAndSettle()` appropriately
- Verify widget tree with `tester.dumpWidgetTree()`

This comprehensive testing guide ensures the KRPG Flutter app maintains high quality and reliability through thorough testing coverage. 