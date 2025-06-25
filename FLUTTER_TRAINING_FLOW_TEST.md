# Flutter Training Flow Integration Tests

This directory contains a comprehensive Flutter integration testing system for the complete KRPG training flow, testing both Coach and Athlete user journeys from the frontend perspective.

## 🎯 What It Tests

The Flutter integration tests cover the complete training workflow from the mobile app perspective:

### 🏆 Coach Flow
1. **Login** - Coach authentication with credentials
2. **Navigation** - Navigate to training section
3. **Training Selection** - Find and select test training
4. **Training Details** - View training information and participants
5. **Session Start** - Initiate training session
6. **Attendance Monitoring** - Monitor athlete attendance in real-time
7. **Session Management** - Manage ongoing training session
8. **Statistics Recording** - Record athlete performance data
9. **Session Completion** - End training session properly

### 🏃 Athlete Flow
1. **Login** - Athlete authentication with credentials
2. **Navigation** - Navigate to training section
3. **Training Discovery** - Find available/active trainings
4. **Session Joining** - Join active training session
5. **Attendance Marking** - Mark attendance with location
6. **Session Participation** - Participate in training session
7. **Progress Tracking** - View session progress and updates

### 👥 Concurrent Flow
- Tests both Coach and Athlete flows in sequence
- Validates multi-user scenarios
- Ensures real-time synchronization

## 📁 Files Overview

- `integration_test/training_flow_integration_test.dart` - Main integration test file
- `test_runner.dart` - Dart test runner with CLI options
- `run_flutter_tests.ps1` - PowerShell script for easy execution
- `FLUTTER_TRAINING_FLOW_TEST.md` - This documentation

## 🚀 Quick Start

### Method 1: PowerShell Script (Recommended)

```powershell
# Basic test run with setup
.\run_flutter_tests.ps1 -Setup

# Run only coach flow
.\run_flutter_tests.ps1 -CoachOnly -Setup

# Run on specific device with verbose output
.\run_flutter_tests.ps1 -Device chrome -Verbose

# Get help
.\run_flutter_tests.ps1 -Help
```

### Method 2: Dart Test Runner

```bash
# Basic test run with setup
dart test_runner.dart --setup

# Run only athlete flow
dart test_runner.dart --athlete-only

# Run on specific device
dart test_runner.dart --device chrome --verbose
```

### Method 3: Direct Flutter Command

```bash
# Run all integration tests
flutter test integration_test/training_flow_integration_test.dart

# Run on specific device
flutter test integration_test/training_flow_integration_test.dart -d chrome

# Run specific test
flutter test integration_test/training_flow_integration_test.dart --name "Complete Coach Training Flow"
```

## 🧪 Test Data Requirements

The tests use the same test data as the backend tests:

- **Coach Account**: `test.coach@krpg.com` / `password123`
- **Athlete Accounts**: `test.athlete1@krpg.com` to `test.athlete5@krpg.com` / `password123`
- **Test Training**: "Test Training Session" scheduled for 1 hour from seeding
- **Test Location**: Jakarta coordinates (-6.2088, 106.8456)

### Setting Up Test Data

```bash
# From backend directory
php artisan db:seed --class=TrainingFlowTestSeeder

# Or use the -Setup flag in test scripts
.\run_flutter_tests.ps1 -Setup
```

## 🔧 Prerequisites

### 1. Backend Server
```bash
# Start Laravel server
php artisan serve --host=localhost --port=8000
```

### 2. Flutter Environment
```bash
# Check Flutter installation
flutter doctor

# Get dependencies
flutter pub get
```

### 3. Test Device/Emulator
```bash
# Check available devices
flutter devices

# Start Android emulator (if needed)
flutter emulators --launch <emulator_id>

# Or use Chrome for web testing
# (Chrome should be available automatically)
```

## 📱 Supported Platforms

- **Android Emulator** - Full testing support
- **iOS Simulator** - Full testing support (macOS only)
- **Chrome Web** - Full testing support
- **Physical Devices** - Full testing support

## 🧪 Test Structure

### Test Keys Used

The tests rely on specific widget keys added to UI components:

```dart
// Login Screen
Key('email_field')        // Email/username input
Key('password_field')     // Password input
Key('login_button')       // Login button

// Navigation
Key('training_nav')       // Training navigation item

// Training Flow
Key('start_training_button')     // Start training (coach)
Key('join_training_button')      // Join training (athlete)
Key('mark_attendance_button')    // Mark attendance
Key('attendance_tab')            // Attendance tab
Key('session_tab')               // Session management tab
Key('statistics_tab')            // Statistics tab
Key('end_attendance_button')     // End attendance phase
Key('end_session_button')        // End session
Key('progress_tab')              // Progress tracking
```

### Test Helpers

The test includes helper extensions for robust testing:

```dart
// Wait for network requests
await tester.waitForNetwork();

// Find text with retry mechanism
await tester.findTextWithRetry('Training Details');

// Tap with retry for flaky elements
await tester.tapWithRetry(find.byKey(Key('login_button')));
```

## 🐛 Troubleshooting

### Common Issues

1. **"Test data not found"**
   ```bash
   # Ensure backend test data is seeded
   php artisan db:seed --class=TrainingFlowTestSeeder
   ```

2. **"Backend server not accessible"**
   ```bash
   # Start Laravel server
   php artisan serve --host=localhost --port=8000
   ```

3. **"No Flutter devices found"**
   ```bash
   # Check available devices
   flutter devices
   
   # Start an emulator
   flutter emulators --launch <emulator_id>
   ```

4. **"Widget not found" errors**
   - Ensure UI components have the correct test keys
   - Check if screens are loading properly
   - Verify navigation flow

5. **"Integration test package not found"**
   ```bash
   # Add integration_test dependency
   flutter pub add integration_test --dev
   flutter pub get
   ```

### Debug Mode

For detailed debugging, use verbose mode:

```powershell
.\run_flutter_tests.ps1 -Verbose
```

Or add debug prints in the test:

```dart
print('🐛 Current screen: ${find.text('Training').evaluate()}');
await tester.pumpAndSettle();
```

## 📊 Expected Test Output

Successful test run should show:

```
🚀 Flutter Training Flow Test Runner
====================================

🔍 Checking environment...
   ✓ Flutter SDK available
   ✓ Backend server is running
   ✓ Flutter devices available

🌱 Setting up test data...
   ✓ Test data seeded successfully

📦 Getting Flutter dependencies...
   ✓ Dependencies updated

🧪 Running Flutter integration tests...

🏆 Testing Coach Training Flow
================================
🔐 Testing coach login...
   ✓ Coach logged in successfully
🧭 Navigating to training section...
   ✓ Training section loaded
🎯 Selecting test training...
   ✓ Test training selected
📋 Viewing training details...
   ✓ Training details loaded
🏁 Starting training session...
   ✓ Training session started
✋ Monitoring attendance...
   ✓ Attendance monitoring active
⚡ Managing session...
   ✓ Session management available
📊 Recording statistics...
   ✓ Statistics recording available
🏁 Ending session...
   ✓ Session ended successfully
✅ Coach flow completed successfully!

🏃 Testing Athlete Training Flow
=================================
🔐 Testing athlete login...
   ✓ Athlete logged in successfully
🧭 Navigating to training section...
   ✓ Training section loaded
🔍 Finding available training...
   ✓ Available training found
🤝 Joining training session...
   ✓ Joined training session
✅ Marking attendance...
   ✓ Attendance marked
🏃 Participating in session...
   ✓ Session participation active
📈 Viewing session progress...
   ✓ Session progress visible
✅ Athlete flow completed successfully!

✅ All tests passed!
```

## 🔄 Continuous Integration

### GitHub Actions Example

```yaml
name: Flutter Integration Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          
      - name: Setup Backend
        run: |
          cd ../backend
          php artisan serve &
          php artisan db:seed --class=TrainingFlowTestSeeder
          
      - name: Run Integration Tests
        run: |
          flutter pub get
          flutter test integration_test/training_flow_integration_test.dart -d chrome
```

## 📈 Performance Considerations

- Tests use `pumpAndSettle()` with timeouts to handle async operations
- Network requests are given adequate time to complete
- Location permissions are handled gracefully
- Memory usage is monitored during long test runs

## 🔐 Security Testing

The integration tests validate:
- Authentication token handling
- Session management
- Role-based UI access control
- Data privacy in multi-user scenarios

## 🎛️ Configuration

### API Base URL
Tests use the API service configuration. Update `lib/services/api_service.dart` if needed:

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
// or
static const String baseUrl = 'http://localhost:8000/api'; // Web/iOS
```

### Test Timeouts
Adjust timeouts in test helpers if needed:

```dart
Future<void> waitForNetwork({Duration timeout = const Duration(seconds: 5)})
```

---

**Need Help?** 
- Check Flutter logs: `flutter logs`
- Check backend logs: `storage/logs/laravel.log`
- Use verbose mode for detailed output
- Ensure all prerequisites are met 