class AppConfig {
  static const String appName = 'SiMenang KRPG';
  
  // Data Mode Configuration
  static const bool useMockMode = true; // Set to true for UEQ-S testing
  static const bool isDummyDataForUEQSTest = true; // Special flag for UEQ-S testing
  
  // API Configuration
  static const String baseUrl = 'https://10.0.2.2:8000/api';
  static const String apiVersion = 'v1';
  
  // App Settings
  static const int timeoutDuration = 30;
  static const bool enableLogging = true;
  
  // UEQ-S Testing Configuration
  static const String ueqsTestVersion = '1.0.0';
  static const bool showDummyDataIndicator = true; // Show indicator that app is using dummy data
  static const String dummyUserRole = 'coach'; // 'coach' or 'athlete' for testing different perspectives
  
  // Mock Data Settings
  static const int mockTrainingSessions = 30;  // Increased for better UEQ-S testing
  static const int mockAthletes = 25;
  static const int mockClassrooms = 8;
  static const int mockCompetitions = 6;
  static const int mockAttendanceRecords = 75;
} 