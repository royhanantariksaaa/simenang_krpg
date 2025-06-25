import 'dart:math';
import '../config/app_config.dart';
import 'dummy_data_service.dart';

class OfflineDataManager {
  static final OfflineDataManager _instance = OfflineDataManager._internal();
  factory OfflineDataManager() => _instance;
  OfflineDataManager._internal();

  final DummyDataService _dummyDataService = DummyDataService();
  final Random _random = Random();
  
  // Cache untuk data dummy
  List<Map<String, dynamic>>? _athletes;
  List<Map<String, dynamic>>? _trainingSessions;
  List<Map<String, dynamic>>? _classrooms;
  List<Map<String, dynamic>>? _competitions;
  List<Map<String, dynamic>>? _attendance;
  Map<String, dynamic>? _dashboardStats;

  // Initialize all dummy data
  void initializeData() {
    if (!AppConfig.isDummyDataForUEQSTest) return;
    
    _athletes = _dummyDataService.generateDummyAthletes();
    _trainingSessions = _dummyDataService.generateDummyTrainingSessions();
    _classrooms = _dummyDataService.generateDummyClassrooms();
    _competitions = _dummyDataService.generateDummyCompetitions();
    _attendance = _dummyDataService.generateDummyAttendance();
    _dashboardStats = _dummyDataService.generateDashboardStats();
    
    print('🧪 Offline Data Manager: All dummy data initialized');
    print('🧪 Athletes: ${_athletes?.length ?? 0}');
    print('🧪 Training Sessions: ${_trainingSessions?.length ?? 0}');
    print('🧪 Classrooms: ${_classrooms?.length ?? 0}');
    print('🧪 Competitions: ${_competitions?.length ?? 0}');
    print('🧪 Attendance: ${_attendance?.length ?? 0}');
  }

  // Get Athletes
  Future<Map<String, dynamic>> getAthletes({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay

    if (_athletes == null) initializeData();

    var filteredAthletes = _athletes!;
    
    if (search != null && search.isNotEmpty) {
      filteredAthletes = _athletes!.where((athlete) {
        final name = athlete['name'].toString().toLowerCase();
        final email = athlete['email'].toString().toLowerCase();
        return name.contains(search.toLowerCase()) || 
               email.contains(search.toLowerCase());
      }).toList();
    }

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedData = filteredAthletes.sublist(
      startIndex,
      endIndex > filteredAthletes.length ? filteredAthletes.length : endIndex,
    );

    return <String, dynamic>{
      'success': true,
      'data': paginatedData.map((athlete) => Map<String, dynamic>.from(athlete)).toList(),
      'pagination': <String, dynamic>{
        'current_page': page,
        'per_page': limit,
        'total': filteredAthletes.length,
        'last_page': (filteredAthletes.length / limit).ceil(),
      },
    };
  }

  // Get Single Athlete
  Future<Map<String, dynamic>> getAthlete(int id) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (_athletes == null) initializeData();

    final athlete = _athletes!.firstWhere(
      (a) => a['id'] == id,
      orElse: () => throw Exception('Athlete not found'),
    );

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(athlete),
    };
  }

  // Get Training Sessions
  Future<Map<String, dynamic>> getTrainingSessions({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    if (_trainingSessions == null) initializeData();

    var filteredSessions = _trainingSessions!;
    
    if (status != null && status.isNotEmpty) {
      filteredSessions = _trainingSessions!.where((session) {
        return session['status'] == status;
      }).toList();
    }

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final paginatedData = filteredSessions.sublist(
      startIndex,
      endIndex > filteredSessions.length ? filteredSessions.length : endIndex,
    );

    print('🧪 OfflineDataManager getTrainingSessions:');
    print('🧪 Total sessions: ${_trainingSessions?.length ?? 0}');
    print('🧪 Filtered sessions: ${filteredSessions.length}');
    print('🧪 Paginated data: ${paginatedData.length}');
    print('🧪 Status filter: $status');

    return <String, dynamic>{
      'success': true,
      'data': paginatedData.map((session) => Map<String, dynamic>.from(session)).toList(),
      'pagination': <String, dynamic>{
        'current_page': page,
        'per_page': limit,
        'total': filteredSessions.length,
        'last_page': (filteredSessions.length / limit).ceil(),
      },
    };
  }

  // Get Classrooms
  Future<Map<String, dynamic>> getClassrooms() async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 250));

    if (_classrooms == null) initializeData();

    return <String, dynamic>{
      'success': true,
      'data': _classrooms!.map((classroom) => Map<String, dynamic>.from(classroom)).toList(),
    };
  }

  // Get Competitions
  Future<Map<String, dynamic>> getCompetitions({
    String? status,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    if (_competitions == null) initializeData();

    var filteredCompetitions = _competitions!;
    
    if (status != null && status.isNotEmpty) {
      filteredCompetitions = _competitions!.where((comp) {
        return comp['status'] == status;
      }).toList();
    }

    return <String, dynamic>{
      'success': true,
      'data': filteredCompetitions.map((comp) => Map<String, dynamic>.from(comp)).toList(),
    };
  }

  // Get Attendance
  Future<Map<String, dynamic>> getAttendance({
    int? athleteId,
    int? sessionId,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (_attendance == null) initializeData();

    var filteredAttendance = _attendance!;
    
    if (athleteId != null) {
      filteredAttendance = filteredAttendance.where((att) {
        return att['athleteId'] == athleteId;
      }).toList();
    }
    
    if (sessionId != null) {
      filteredAttendance = filteredAttendance.where((att) {
        return att['trainingSessionId'] == sessionId;
      }).toList();
    }

    return <String, dynamic>{
      'success': true,
      'data': filteredAttendance.map((att) => Map<String, dynamic>.from(att)).toList(),
    };
  }

  // Get Dashboard Statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 400));

    if (_dashboardStats == null) initializeData();

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(_dashboardStats!),
    };
  }

  // Create Training Session (dummy)
  Future<Map<String, dynamic>> createTrainingSession(Map<String, dynamic> data) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (_trainingSessions == null) initializeData();

    final newSession = <String, dynamic>{
      'id': _trainingSessions!.length + 1,
      ...Map<String, dynamic>.from(data),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    _trainingSessions!.add(newSession);

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(newSession),
      'message': 'Training session created successfully',
    };
  }

  // Update Training Session (dummy)
  Future<Map<String, dynamic>> updateTrainingSession(int id, Map<String, dynamic> data) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 400));

    if (_trainingSessions == null) initializeData();

    final index = _trainingSessions!.indexWhere((session) => session['id'] == id);
    if (index == -1) {
      throw Exception('Training session not found');
    }

    _trainingSessions![index] = <String, dynamic>{
      ...Map<String, dynamic>.from(_trainingSessions![index]),
      ...Map<String, dynamic>.from(data),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(_trainingSessions![index]),
      'message': 'Training session updated successfully',
    };
  }

  // Get Training Details
  Future<Map<String, dynamic>> getTrainingDetails(int id) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    if (_trainingSessions == null) initializeData();

    print('🧪 OfflineDataManager getTrainingDetails: Looking for training ID $id');
    print('🧪 Available training IDs: ${_trainingSessions!.map((s) => s['id']).take(5).toList()}...');

    final training = _trainingSessions!.firstWhere(
      (session) => session['id'] == id,
      orElse: () => throw Exception('Training not found'),
    );

    print('🧪 Found training: ${training['title']} at ${training['start_time']}');

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(training),
    };
  }

  // Check if training can be started
  Future<Map<String, dynamic>> canStartTraining(int id) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (_trainingSessions == null) initializeData();

    final training = _trainingSessions!.firstWhere(
      (session) => session['id'] == id,
      orElse: () => throw Exception('Training not found'),
    );

    final now = DateTime.now();
    final startTime = DateTime.parse(training['datetime']);
    final status = training['status'];
    
    // Training can be started if:
    // 1. Status is 'scheduled' (1) or 'ongoing' (2)
    // 2. For UEQ-S testing, allow starting if within 2 hours or if today/tomorrow
    final timeDiff = startTime.difference(now).inMinutes.abs();
    final isToday = startTime.day == now.day && startTime.month == now.month && startTime.year == now.year;
    final isTomorrow = startTime.day == now.add(Duration(days: 1)).day && startTime.month == now.month && startTime.year == now.year;
    
    final canStart = (status == '1' || status == '2') && (timeDiff <= 120 || isToday || isTomorrow);

    return <String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'canStart': canStart,
        'reason': canStart ? 'Training can be started' : 'Training cannot be started at this time',
        'currentTime': now.toIso8601String(),
        'startTime': training['datetime'],
        'status': status,
        'timeDifferenceMinutes': timeDiff,
      },
    };
  }

  // Get Training Athletes
  Future<Map<String, dynamic>> getTrainingAthletes(int trainingId) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 250));

    if (_athletes == null) initializeData();

    // Return random subset of athletes for this training
    final shuffledAthletes = List<Map<String, dynamic>>.from(_athletes!)..shuffle();
    final trainingAthletes = shuffledAthletes.take(5 + _random.nextInt(10)).toList();

    return <String, dynamic>{
      'success': true,
      'data': trainingAthletes.map((athlete) => Map<String, dynamic>.from(athlete)).toList(),
    };
  }

  // Mark Attendance (dummy implementation)
  Future<Map<String, dynamic>> markAttendance({
    required String sessionId,
    String? profileId,
    String status = '2',
    String? note,
    Map<String, double>? location,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    print('🧪 OfflineDataManager markAttendance:');
    print('🧪 Session ID: $sessionId');
    print('🧪 Profile ID: $profileId'); 
    print('🧪 Status: $status');
    print('🧪 Location: $location');

    // Validate session ID
    if (sessionId.isEmpty) {
      throw Exception('Session ID is required');
    }

    // For UEQ-S testing, always succeed
    final attendanceRecord = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch,
      'session_id': sessionId,
      'profile_id': profileId ?? 'current_user',
      'status': status,
      'note': note,
      'location': location,
      'marked_at': DateTime.now().toIso8601String(),
    };

    // Add to cache
    if (_attendance == null) initializeData();
    _attendance!.add(attendanceRecord);

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(attendanceRecord),
      'message': 'Attendance marked successfully',
    };
  }

  // Get Session Statistics (dummy)
  Future<Map<String, dynamic>> getSessionStatistics(String sessionId) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    print('🧪 OfflineDataManager getSessionStatistics: Session ID $sessionId');

    // Return dummy statistics
    return <String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'session_id': sessionId,
        'total_athletes': 5,
        'present': 4,
        'absent': 1,
        'late': 0,
        'statistics': [
          {
            'athlete_name': 'Ahmad Santoso',
            'stroke': 'freestyle',
            'duration': '01:25:30',
            'distance': 100,
          },
          {
            'athlete_name': 'Sari Wijaya', 
            'stroke': 'backstroke',
            'duration': '01:28:15',
            'distance': 100,
          },
        ],
      },
    };
  }

  // Record Statistics (dummy)
  Future<Map<String, dynamic>> recordStatistics({
    required String sessionId,
    required String profileId,
    required String stroke,
    String? duration,
    int? distance,
    String? energySystem,
    String? note,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 400));

    print('🧪 OfflineDataManager recordStatistics:');
    print('🧪 Session ID: $sessionId');
    print('🧪 Profile ID: $profileId');
    print('🧪 Stroke: $stroke');
    print('🧪 Duration: $duration');
    print('🧪 Distance: $distance');

    // For UEQ-S testing, always succeed
    final statisticsRecord = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch,
      'session_id': sessionId,
      'profile_id': profileId,
      'stroke': stroke,
      'duration': duration,
      'distance': distance,
      'energy_system': energySystem ?? 'aerobic_11',
      'note': note,
      'recorded_at': DateTime.now().toIso8601String(),
    };

    return <String, dynamic>{
      'success': true,
      'data': Map<String, dynamic>.from(statisticsRecord),
      'message': 'Statistics recorded successfully',
    };
  }

  // End Attendance Phase (dummy)
  Future<Map<String, dynamic>> endAttendance(String sessionId) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    print('🧪 OfflineDataManager endAttendance: Session ID $sessionId');

    return <String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'session_id': sessionId,
        'attendance_phase_ended': true,
        'ended_at': DateTime.now().toIso8601String(),
      },
      'message': 'Attendance phase ended successfully',
    };
  }

  // End Training Session (dummy)
  Future<Map<String, dynamic>> endSession(String sessionId) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    print('🧪 OfflineDataManager endSession: Session ID $sessionId');

    return <String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'session_id': sessionId,
        'session_ended': true,
        'ended_at': DateTime.now().toIso8601String(),
        'final_status': 'completed',
      },
      'message': 'Training session ended successfully',
    };
  }

  // Start Training
  Future<Map<String, dynamic>> startTraining(int id) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 400));

    if (_trainingSessions == null) initializeData();

    final index = _trainingSessions!.indexWhere((session) => session['id'] == id);
    if (index == -1) {
      throw Exception('Training session not found');
    }

    // Update training status to ongoing
    _trainingSessions![index]['status'] = '2'; // ongoing
    _trainingSessions![index]['updatedAt'] = DateTime.now().toIso8601String();

    return <String, dynamic>{
      'success': true,
      'data': <String, dynamic>{
        'id': id,
        'status': 'started',
        'message': 'Training session started successfully',
        'startedAt': DateTime.now().toIso8601String(),
      },
    };
  }

  // Check In/Out Attendance (dummy)
  Future<Map<String, dynamic>> checkInOut({
    required int athleteId,
    required int sessionId,
    required String action, // 'checkin' or 'checkout'
    double? lat,
    double? lng,
  }) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 600));

    if (_attendance == null) initializeData();

    final now = DateTime.now();
    
    if (action == 'checkin') {
      final newAttendance = <String, dynamic>{
        'id': _attendance!.length + 1,
        'athleteId': athleteId,
        'trainingSessionId': sessionId,
        'checkInTime': now.toIso8601String(),
        'checkOutTime': null,
        'status': 'present',
        'notes': 'Checked in via mobile app',
        'locationLat': lat ?? -6.2088,
        'locationLng': lng ?? 106.8456,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      _attendance!.add(newAttendance);

      return <String, dynamic>{
        'success': true,
        'data': Map<String, dynamic>.from(newAttendance),
        'message': 'Check-in successful',
      };
    } else {
      // Find existing attendance record
      final index = _attendance!.indexWhere((att) => 
        att['athleteId'] == athleteId && 
        att['trainingSessionId'] == sessionId &&
        att['checkOutTime'] == null
      );

      if (index == -1) {
        throw Exception('No active check-in found');
      }

      _attendance![index]['checkOutTime'] = now.toIso8601String();
      _attendance![index]['updatedAt'] = now.toIso8601String();

      return <String, dynamic>{
        'success': true,
        'data': Map<String, dynamic>.from(_attendance![index]),
        'message': 'Check-out successful',
      };
    }
  }

  // Generic GET method for other endpoints
  Future<Map<String, dynamic>> get(String endpoint) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // Handle various endpoints with dummy responses
    switch (endpoint) {
      case 'profile':
        return <String, dynamic>{
          'success': true,
          'data': Map<String, dynamic>.from(_dummyDataService.generateDummyUser()),
        };
      
      case 'notifications':
        return <String, dynamic>{
          'success': true,
          'data': <Map<String, dynamic>>[],
        };
        
      default:
        return <String, dynamic>{
          'success': true,
          'data': <String, dynamic>{},
          'message': 'Dummy response for $endpoint',
        };
    }
  }

  // Generic POST method for other endpoints
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    if (!AppConfig.isDummyDataForUEQSTest) {
      throw Exception('Offline mode only available in UEQ-S testing mode');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    return <String, dynamic>{
      'success': true,
      'data': body != null ? Map<String, dynamic>.from(body) : <String, dynamic>{},
      'message': 'Dummy response for $endpoint',
    };
  }

  // Clear all cached data
  void clearCache() {
    _athletes = null;
    _trainingSessions = null;
    _classrooms = null;
    _competitions = null;
    _attendance = null;
    _dashboardStats = null;
    
    print('🧪 Offline Data Manager: Cache cleared');
  }
} 