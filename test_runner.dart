import 'dart:io';

/// Flutter Training Flow Test Runner
/// 
/// This script helps run the Flutter integration tests for the training flow
/// Usage: dart test_runner.dart [options]
void main(List<String> args) async {
  print('🚀 Flutter Training Flow Test Runner');
  print('====================================');
  print('');

  // Parse command line arguments
  final options = parseArgs(args);
  
  if (options['help'] == true) {
    printHelp();
    return;
  }

  try {
    // Step 1: Check environment
    await checkEnvironment();
    
    // Step 2: Setup test data if requested
    if (options['setup'] == true) {
      await setupTestData();
    }
    
    // Step 3: Run tests
    await runTests(options);
    
    print('\n✅ All tests completed successfully!');
    
  } catch (e) {
    print('\n❌ Test execution failed: $e');
    exit(1);
  }
}

Map<String, dynamic> parseArgs(List<String> args) {
  final options = <String, dynamic>{
    'help': false,
    'setup': false,
    'device': null,
    'verbose': false,
    'coach-only': false,
    'athlete-only': false,
  };

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--help':
      case '-h':
        options['help'] = true;
        break;
      case '--setup':
      case '-s':
        options['setup'] = true;
        break;
      case '--device':
      case '-d':
        if (i + 1 < args.length) {
          options['device'] = args[i + 1];
          i++;
        }
        break;
      case '--verbose':
      case '-v':
        options['verbose'] = true;
        break;
      case '--coach-only':
        options['coach-only'] = true;
        break;
      case '--athlete-only':
        options['athlete-only'] = true;
        break;
    }
  }

  return options;
}

void printHelp() {
  print('''
Flutter Training Flow Test Runner

Usage: dart test_runner.dart [options]

Options:
  -h, --help          Show this help message
  -s, --setup         Setup test data on backend before running tests
  -d, --device <id>   Specify device to run tests on
  -v, --verbose       Enable verbose logging
  --coach-only        Run only coach flow tests
  --athlete-only      Run only athlete flow tests

Examples:
  dart test_runner.dart --setup
  dart test_runner.dart --device chrome --verbose
  dart test_runner.dart --coach-only --setup
  
Prerequisites:
  1. Backend server running on localhost:8000
  2. Test data seeded (use --setup flag)
  3. Flutter device/emulator available
  ''');
}

Future<void> checkEnvironment() async {
  print('🔍 Checking environment...');
  
  // Check if Flutter is available
  final flutterResult = await Process.run('flutter', ['--version']);
  if (flutterResult.exitCode != 0) {
    throw Exception('Flutter not found. Please install Flutter SDK.');
  }
  print('   ✓ Flutter SDK available');
  
  // Check if backend server is running
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse('http://localhost:8000/api/health'));
    final response = await request.close();
    
    if (response.statusCode == 200) {
      print('   ✓ Backend server is running');
    } else {
      throw Exception('Backend server returned status ${response.statusCode}');
    }
    client.close();
  } catch (e) {
    throw Exception('Backend server not accessible. Please start with: php artisan serve');
  }
  
  // Check for available devices
  final devicesResult = await Process.run('flutter', ['devices']);
  if (devicesResult.exitCode != 0) {
    throw Exception('Failed to get Flutter devices');
  }
  
  final devicesOutput = devicesResult.stdout.toString();
  if (devicesOutput.contains('No devices found')) {
    throw Exception('No Flutter devices found. Please start an emulator or connect a device.');
  }
  print('   ✓ Flutter devices available');
  
  print('');
}

Future<void> setupTestData() async {
  print('🌱 Setting up test data...');
  
  // Change to backend directory and run seeder
  final backendDir = '../../../Web/KRPG/KRPG_Website';
  
  final result = await Process.run(
    'php',
    ['artisan', 'db:seed', '--class=TrainingFlowTestSeeder'],
    workingDirectory: backendDir,
  );
  
  if (result.exitCode != 0) {
    throw Exception('Failed to seed test data: ${result.stderr}');
  }
  
  print('   ✓ Test data seeded successfully');
  print('');
}

Future<void> runTests(Map<String, dynamic> options) async {
  print('🧪 Running Flutter integration tests...');
  print('');
  
  final testArgs = <String>[
    'test',
    'integration_test/training_flow_integration_test.dart',
  ];
  
  // Add device if specified
  if (options['device'] != null) {
    testArgs.addAll(['-d', options['device']]);
  }
  
  // Add verbose flag if requested
  if (options['verbose'] == true) {
    testArgs.add('--verbose');
  }
  
  // Run specific test groups if requested
  if (options['coach-only'] == true) {
    testArgs.addAll(['--name', 'Complete Coach Training Flow']);
  } else if (options['athlete-only'] == true) {
    testArgs.addAll(['--name', 'Complete Athlete Training Flow']);
  }
  
  print('Running command: flutter ${testArgs.join(' ')}');
  print('');
  
  final result = await Process.run('flutter', testArgs);
  
  if (result.exitCode != 0) {
    print('❌ Test execution failed:');
    print(result.stdout);
    print(result.stderr);
    throw Exception('Integration tests failed');
  }
  
  print('✅ Integration tests passed!');
  print(result.stdout);
} 