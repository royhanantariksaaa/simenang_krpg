import 'dart:math';
import '../config/app_config.dart';

class DummyDataService {
  static final DummyDataService _instance = DummyDataService._internal();
  factory DummyDataService() => _instance;
  DummyDataService._internal();

  final Random _random = Random();

  // Indonesian names for realistic dummy data
  final List<String> _athleteFirstNames = [
    'Ahmad', 'Budi', 'Citra', 'Dewi', 'Eko', 'Fajar', 'Gita', 'Hadi',
    'Indra', 'Joko', 'Kartika', 'Lina', 'Made', 'Nina', 'Oscar', 'Putri',
    'Qomar', 'Rina', 'Sari', 'Tono', 'Udin', 'Vina', 'Wawan', 'Yani', 'Zaki'
  ];

  final List<String> _athleteLastNames = [
    'Pratama', 'Sari', 'Wijaya', 'Putri', 'Santoso', 'Wati', 'Kusuma',
    'Dewi', 'Permana', 'Lestari', 'Setiawan', 'Anggraini', 'Nugroho',
    'Rahayu', 'Firmansyah', 'Safitri', 'Budiman', 'Maharani'
  ];

  final List<String> _trainingTypes = [
    'Latihan Fisik Dasar', 'Latihan Teknik', 'Latihan Taktik', 'Sparring',
    'Kondisi Fisik', 'Latihan Mental', 'Analisis Video', 'Recovery Session'
  ];

  final List<String> _classroomNames = [
    'Kelas Pemula A', 'Kelas Pemula B', 'Kelas Menengah A', 'Kelas Menengah B',
    'Kelas Lanjutan A', 'Kelas Lanjutan B', 'Kelas Kompetisi', 'Kelas Khusus'
  ];

  final List<String> _competitionNames = [
    'Kejuaraan Provinsi 2024', 'Tournament Nasional Junior', 'Liga Regional',
    'Kompetisi Antar Klub', 'Championship Series', 'Open Tournament'
  ];

  // Generate dummy data as Map for easier handling
  List<Map<String, dynamic>> generateDummyAthletes() {
    List<Map<String, dynamic>> athletes = [];
    
    for (int i = 1; i <= AppConfig.mockAthletes; i++) {
      final firstName = _athleteFirstNames[_random.nextInt(_athleteFirstNames.length)];
      final lastName = _athleteLastNames[_random.nextInt(_athleteLastNames.length)];
      
      athletes.add({
        'id': i,
        'name': '$firstName $lastName',
        'email': '${firstName.toLowerCase()}.${lastName.toLowerCase()}@email.com',
        'phone': '08${_random.nextInt(99999999).toString().padLeft(8, '0')}',
        'birthDate': DateTime.now().subtract(Duration(days: 365 * (16 + _random.nextInt(15)))).toIso8601String(),
        'weight': 50.0 + _random.nextDouble() * 40.0,
        'height': 150.0 + _random.nextDouble() * 30.0,
        'classroomId': _random.nextInt(AppConfig.mockClassrooms) + 1,
        'profileImageUrl': 'https://ui-avatars.com/api/?name=$firstName+$lastName&background=10B981&color=fff',
        'isActive': _random.nextBool() || _random.nextBool(), // 75% chance of being active
        'joinDate': DateTime.now().subtract(Duration(days: _random.nextInt(730))).toIso8601String(),
        'achievements': _generateAchievements(),
        'lastTrainingDate': DateTime.now().subtract(Duration(days: _random.nextInt(30))).toIso8601String(),
      });
    }
    
    return athletes;
  }

  // Generate dummy training sessions
  List<Map<String, dynamic>> generateDummyTrainingSessions() {
    List<Map<String, dynamic>> sessions = [];
    
    for (int i = 1; i <= AppConfig.mockTrainingSessions; i++) {
      // Mix of past, current, and future training sessions for realistic testing
      late DateTime startTime;
      final status = _getRandomTrainingStatus();
      
      if (status == 'scheduled') {
        // Future sessions - some today, some future for better testing
        final daysFromNow = _random.nextInt(7); // 0-6 days from now
        final hour = 8 + _random.nextInt(10); // 8-17 (8 AM - 5 PM)
        final minute = [0, 15, 30, 45][_random.nextInt(4)]; // Quarter hours
        startTime = DateTime.now().add(Duration(days: daysFromNow)).copyWith(
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
        );
      } else if (status == 'ongoing') {
        // Sessions happening today - within the last 2 hours or next 2 hours
        final hoursOffset = _random.nextInt(4) - 2; // -2 to +2 hours from now
        startTime = DateTime.now().add(Duration(hours: hoursOffset)).copyWith(
          minute: [0, 15, 30, 45][_random.nextInt(4)],
          second: 0,
          millisecond: 0,
        );
      } else {
        // Past sessions for completed/cancelled
        final daysAgo = _random.nextInt(30) + 1; // 1-30 days ago
        final hour = 8 + _random.nextInt(10); // 8-17 (8 AM - 5 PM)
        final minute = [0, 15, 30, 45][_random.nextInt(4)]; // Quarter hours
        startTime = DateTime.now().subtract(Duration(days: daysAgo)).copyWith(
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
        );
      }
      
      // Calculate end time properly
      final duration = 1 + _random.nextInt(3); // 1-3 hours
      final endTime = startTime.add(Duration(hours: duration));
      
      // Create training session that matches Training model format
      sessions.add({
        'id': i,
        'id_training': i.toString(),
        'title': _trainingTypes[_random.nextInt(_trainingTypes.length)],
        'description': 'Sesi latihan komprehensif untuk meningkatkan kemampuan atlet dalam berbagai aspek teknik dan fisik.',
        'datetime': startTime.toIso8601String(),
        'start_time': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
        'end_time': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
        'status': _mapStatusToTrainingStatus(status),
        'id_location': '1',
        'location': {
          'id': 1,
          'name': 'Gedung Olahraga ${String.fromCharCode(65 + _random.nextInt(5))}',
          'address': 'Jl. Olahraga No. ${10 + _random.nextInt(90)}',
          'latitude': -6.2088 + (_random.nextDouble() - 0.5) * 0.1,
          'longitude': 106.8456 + (_random.nextDouble() - 0.5) * 0.1,
        },
        'coach_name': 'Pelatih Ahmad Santoso',
        'classroom_name': _classroomNames[_random.nextInt(_classroomNames.length)],
        'id_training_phase': null,
        'id_competition': null,
        'create_date': startTime.subtract(Duration(days: 1)).toIso8601String(),
        'create_id': '1',
        'change_date_YN': 'N',
        'id_training_change_date': null,
        'recurrence_days': null,
        'recurring_YN': 'N',
        'sessions': null,
        // Additional fields for dummy data compatibility
        'maxParticipants': 15 + _random.nextInt(20),
        'currentParticipants': _random.nextInt(30),
        'classroomId': _random.nextInt(AppConfig.mockClassrooms) + 1,
        'coachId': 1,
        'notes': _generateTrainingNotes(),
        'createdAt': startTime.subtract(Duration(days: 1)).toIso8601String(),
        'updatedAt': startTime.toIso8601String(),
      });
    }
    
    return sessions;
  }

  // Generate dummy classrooms
  List<Map<String, dynamic>> generateDummyClassrooms() {
    List<Map<String, dynamic>> classrooms = [];
    
    for (int i = 1; i <= AppConfig.mockClassrooms; i++) {
      classrooms.add({
        'id': i,
        'name': _classroomNames[i - 1],
        'description': 'Kelas latihan untuk atlet dengan tingkat kemampuan ${_getClassLevel(i)}',
        'capacity': 20 + _random.nextInt(15),
        'currentMembers': 10 + _random.nextInt(25),
        'coachId': 1,
        'isActive': true,
        'schedule': _generateClassSchedule(),
        'createdAt': DateTime.now().subtract(Duration(days: _random.nextInt(365))).toIso8601String(),
        'updatedAt': DateTime.now().subtract(Duration(days: _random.nextInt(30))).toIso8601String(),
      });
    }
    
    return classrooms;
  }

  // Generate dummy competitions
  List<Map<String, dynamic>> generateDummyCompetitions() {
    List<Map<String, dynamic>> competitions = [];
    
    for (int i = 1; i <= AppConfig.mockCompetitions; i++) {
      final startDate = DateTime.now().add(Duration(days: _random.nextInt(180) - 90));
      
      competitions.add({
        'id': i,
        'name': _competitionNames[i - 1],
        'description': 'Kompetisi resmi untuk mengukur kemampuan dan prestasi atlet dalam pertandingan.',
        'startDate': startDate.toIso8601String(),
        'endDate': startDate.add(Duration(days: 1 + _random.nextInt(3))).toIso8601String(),
        'location': 'Arena Olahraga ${_getCityName()}',
        'maxParticipants': 50 + _random.nextInt(100),
        'currentParticipants': _random.nextInt(150),
        'registrationDeadline': startDate.subtract(Duration(days: 7 + _random.nextInt(14))).toIso8601String(),
        'prize': 'Piala, Medali, dan Uang Pembinaan',
        'rules': 'Sesuai peraturan resmi federasi olahraga nasional',
        'status': _getRandomCompetitionStatus(startDate),
        'createdAt': startDate.subtract(Duration(days: 30 + _random.nextInt(60))).toIso8601String(),
        'updatedAt': DateTime.now().subtract(Duration(days: _random.nextInt(7))).toIso8601String(),
      });
    }
    
    return competitions;
  }

  // Generate dummy attendance records
  List<Map<String, dynamic>> generateDummyAttendance() {
    List<Map<String, dynamic>> attendance = [];
    
    for (int i = 1; i <= AppConfig.mockAttendanceRecords; i++) {
      final checkInTime = DateTime.now().subtract(Duration(days: _random.nextInt(30)));
      
      attendance.add({
        'id': i,
        'athleteId': _random.nextInt(AppConfig.mockAthletes) + 1,
        'trainingSessionId': _random.nextInt(AppConfig.mockTrainingSessions) + 1,
        'checkInTime': checkInTime.toIso8601String(),
        'checkOutTime': _random.nextBool() ? checkInTime.add(Duration(hours: 1 + _random.nextInt(3))).toIso8601String() : null,
        'status': _getRandomAttendanceStatus(),
        'notes': _random.nextBool() ? 'Catatan khusus untuk sesi ini' : null,
        'locationLat': -6.2088 + (_random.nextDouble() - 0.5) * 0.1,
        'locationLng': 106.8456 + (_random.nextDouble() - 0.5) * 0.1,
        'createdAt': checkInTime.toIso8601String(),
        'updatedAt': checkInTime.toIso8601String(),
      });
    }
    
    return attendance;
  }

  // Generate dummy user for testing
  Map<String, dynamic> generateDummyUser({String? role}) {
    final selectedRole = role ?? AppConfig.dummyUserRole;
    final isCoach = selectedRole == 'coach';
    
    return {
      'id': isCoach ? 1 : 2,
      'name': isCoach ? 'Pelatih Ahmad Santoso' : 'Atlet Budi Pratama',
      'email': isCoach ? 'ahmad.santoso@krpg.id' : 'budi.pratama@krpg.id',
      'role': selectedRole,
      'phone': '081234567890',
      'profileImageUrl': 'https://ui-avatars.com/api/?name=${isCoach ? 'Ahmad+Santoso' : 'Budi+Pratama'}&background=10B981&color=fff',
      'isActive': true,
      'joinDate': DateTime.now().subtract(Duration(days: 365)).toIso8601String(),
      'lastLoginAt': DateTime.now().subtract(Duration(hours: _random.nextInt(24))).toIso8601String(),
    };
  }

  // Generate comprehensive dashboard data
  Map<String, dynamic> generateDashboardStats() {
    return {
      'totalAthletes': AppConfig.mockAthletes,
      'activeAthletes': (AppConfig.mockAthletes * 0.8).round(),
      'totalTrainingSessions': AppConfig.mockTrainingSessions,
      'completedSessions': (AppConfig.mockTrainingSessions * 0.7).round(),
      'totalCompetitions': AppConfig.mockCompetitions,
      'upcomingCompetitions': (AppConfig.mockCompetitions * 0.4).round(),
      'totalClassrooms': AppConfig.mockClassrooms,
      'activeClassrooms': AppConfig.mockClassrooms,
      'attendanceRate': (75 + _random.nextInt(20)).toDouble(), // 75-95%
      'monthlyGrowth': (_random.nextInt(10) + 5).toDouble(), // 5-15%
      'avgSessionDuration': (90 + _random.nextInt(60)).toDouble(), // 90-150 minutes
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // Helper methods
  List<String> _generateAchievements() {
    final achievements = [
      'Juara 1 Kompetisi Regional 2023',
      'Medali Emas Tournament Provinsi',
      'Best Athlete Award 2023',
      'Juara 2 Championship Series',
      'Most Improved Player'
    ];
    
    final count = _random.nextInt(3);
    if (count == 0) return [];
    
    return achievements.take(count).toList();
  }

  String _getRandomTrainingStatus() {
    // For UEQ-S testing, ensure more scheduled/upcoming sessions for better flow testing
    final rand = _random.nextDouble();
    if (rand < 0.5) return 'scheduled';      // 50% scheduled (joinable)
    if (rand < 0.6) return 'ongoing';        // 10% ongoing (joinable)
    if (rand < 0.85) return 'completed';     // 25% completed
    return 'cancelled';                      // 15% cancelled
  }

  String _getRandomCompetitionStatus(DateTime startDate) {
    final now = DateTime.now();
    if (startDate.isAfter(now)) return 'upcoming';
    if (startDate.isBefore(now.subtract(Duration(days: 7)))) return 'completed';
    return 'ongoing';
  }

  String _getRandomAttendanceStatus() {
    final statuses = ['present', 'late', 'absent', 'excused'];
    return statuses[_random.nextInt(statuses.length)];
  }

  String _getClassLevel(int index) {
    if (index <= 2) return 'pemula';
    if (index <= 4) return 'menengah';
    if (index <= 6) return 'lanjutan';
    return 'kompetisi';
  }

  String _getCityName() {
    final cities = ['Jakarta', 'Bandung', 'Surabaya', 'Yogyakarta', 'Semarang', 'Medan'];
    return cities[_random.nextInt(cities.length)];
  }

  String _generateTrainingNotes() {
    final notes = [
      'Fokus pada peningkatan teknik dasar',
      'Latihan intensitas tinggi untuk kondisi fisik',
      'Evaluasi kemajuan individual atlet',
      'Persiapan untuk kompetisi mendatang',
      'Sesi recovery dan pemulihan',
    ];
    return notes[_random.nextInt(notes.length)];
  }

  // Map dummy status to Training model status format
  String _mapStatusToTrainingStatus(String status) {
    switch (status) {
      case 'scheduled':
        return '1'; // Active/Scheduled
      case 'ongoing':
        return '2'; // Ongoing
      case 'completed':
        return '3'; // Completed
      case 'cancelled':
        return '0'; // Cancelled/Inactive
      default:
        return '1';
    }
  }

  Map<String, String> _generateClassSchedule() {
    final days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    final times = ['08:00', '10:00', '14:00', '16:00', '18:00'];
    
    Map<String, String> schedule = {};
    final dayCount = 2 + _random.nextInt(3); // 2-4 days per week
    
    for (int i = 0; i < dayCount; i++) {
      final day = days[_random.nextInt(days.length)];
      final time = times[_random.nextInt(times.length)];
      schedule[day] = time;
    }
    
    return schedule;
  }
} 