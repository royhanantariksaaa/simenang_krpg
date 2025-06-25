class Training {
  final String idTraining;
  final String title;
  final String? description;
  final DateTime datetime;
  final String? idTrainingPhase;
  final String? idCompetition;
  final TrainingStatus status;
  final String? idLocation;
  final String? startTime;
  final String? endTime;
  final DateTime? createDate;
  final String? createId;
  final bool changeDate;
  final String? idTrainingChangeDate;
  final int? recurrenceDays;
  final bool recurring;
  final Location? location;
  final String? coachName;
  final String? classroomName;
  final List<TrainingSession>? sessions;

  Training({
    required this.idTraining,
    required this.title,
    this.description,
    required this.datetime,
    this.idTrainingPhase,
    this.idCompetition,
    this.status = TrainingStatus.active,
    this.idLocation,
    this.startTime,
    this.endTime,
    this.createDate,
    this.createId,
    this.changeDate = false,
    this.idTrainingChangeDate,
    this.recurrenceDays,
    this.recurring = false,
    this.location,
    this.coachName,
    this.classroomName,
    this.sessions,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      idTraining: json['id_training']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      datetime: DateTime.parse(json['datetime'] ?? DateTime.now().toIso8601String()),
      idTrainingPhase: json['id_training_phase']?.toString(),
      idCompetition: json['id_competition']?.toString(),
      status: TrainingStatus.fromString(json['status']?.toString() ?? '1'),
      idLocation: json['id_location']?.toString(),
      startTime: json['start_time'],
      endTime: json['end_time'],
      createDate: json['create_date'] != null 
          ? DateTime.parse(json['create_date']) 
          : null,
      createId: json['create_id']?.toString(),
      changeDate: json['change_date_YN'] == 'Y',
      idTrainingChangeDate: json['id_training_change_date']?.toString(),
      recurrenceDays: json['recurrence_days']?.toInt(),
      recurring: json['recurring_YN'] == 'Y',
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      coachName: json['coach_name'],
      classroomName: json['classroom_name'],
      sessions: json['sessions'] != null 
          ? (json['sessions'] as List).map((s) => TrainingSession.fromJson(s)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_training': idTraining,
      'title': title,
      'description': description,
      'datetime': datetime.toIso8601String(),
      'id_training_phase': idTrainingPhase,
      'id_competition': idCompetition,
      'status': status.value,
      'id_location': idLocation,
      'start_time': startTime,
      'end_time': endTime,
      'create_date': createDate?.toIso8601String(),
      'create_id': createId,
      'change_date_YN': changeDate ? 'Y' : 'N',
      'id_training_change_date': idTrainingChangeDate,
      'recurrence_days': recurrenceDays,
      'recurring_YN': recurring ? 'Y' : 'N',
      'location': location?.toJson(),
      'coach_name': coachName,
      'classroom_name': classroomName,
      'sessions': sessions?.map((s) => s.toJson()).toList(),
    };
  }

  String get formattedDate {
    return '${datetime.day}/${datetime.month}/${datetime.year}';
  }

  String get formattedTime {
    return '${startTime ?? ''} - ${endTime ?? ''}';
  }

  bool get canStart {
    final now = DateTime.now();
    final trainingDate = datetime;
    return trainingDate.year == now.year &&
           trainingDate.month == now.month &&
           trainingDate.day == now.day;
  }
}

class TrainingSession {
  final String idTrainingSession;
  final String idTraining;
  final DateTime sessionDate;
  final String? startTime;
  final String? endTime;
  final TrainingSessionStatus status;
  final String? notes;
  final List<Attendance>? attendances;

  TrainingSession({
    required this.idTrainingSession,
    required this.idTraining,
    required this.sessionDate,
    this.startTime,
    this.endTime,
    this.status = TrainingSessionStatus.scheduled,
    this.notes,
    this.attendances,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      idTrainingSession: json['id_training_session']?.toString() ?? '',
      idTraining: json['id_training']?.toString() ?? '',
      sessionDate: DateTime.parse(json['session_date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: TrainingSessionStatus.fromString(json['status']?.toString() ?? '1'),
      notes: json['notes'],
      attendances: json['attendances'] != null 
          ? (json['attendances'] as List).map((a) => Attendance.fromJson(a)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_training_session': idTrainingSession,
      'id_training': idTraining,
      'session_date': sessionDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'status': status.value,
      'notes': notes,
      'attendances': attendances?.map((a) => a.toJson()).toList(),
    };
  }
}

class Attendance {
  final String idAttendance;
  final String idProfile;
  final String idTrainingSession;
  final AttendanceStatus status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? notes;
  final String? athleteName;

  Attendance({
    required this.idAttendance,
    required this.idProfile,
    required this.idTrainingSession,
    this.status = AttendanceStatus.absent,
    this.checkInTime,
    this.checkOutTime,
    this.notes,
    this.athleteName,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      idAttendance: json['id_attendance']?.toString() ?? '',
      idProfile: json['id_profile']?.toString() ?? '',
      idTrainingSession: json['id_training_session']?.toString() ?? '',
      status: AttendanceStatus.fromString(json['status']?.toString() ?? '0'),
      checkInTime: json['check_in_time'] != null 
          ? DateTime.parse(json['check_in_time']) 
          : null,
      checkOutTime: json['check_out_time'] != null 
          ? DateTime.parse(json['check_out_time']) 
          : null,
      notes: json['notes'],
      athleteName: json['athlete_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_attendance': idAttendance,
      'id_profile': idProfile,
      'id_training_session': idTrainingSession,
      'status': status.value,
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'notes': notes,
      'athlete_name': athleteName,
    };
  }
}

class Location {
  final String idLocation;
  final String locationName;
  final String? address;
  final String? description;
  final double? latitude;
  final double? longitude;

  Location({
    required this.idLocation,
    required this.locationName,
    this.address,
    this.description,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    // Helper function to parse coordinates that might be strings or numbers
    double? parseCoordinate(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return Location(
      idLocation: json['id_location']?.toString() ?? '',
      locationName: json['location_name'] ?? '',
      address: json['address'],
      description: json['description'],
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': idLocation,
      'location_name': locationName,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

enum TrainingStatus {
  active('1'),
  inactive('0'),
  cancelled('2'),
  completed('3');

  const TrainingStatus(this.value);
  final String value;

  static TrainingStatus fromString(String value) {
    switch (value) {
      case '1':
        return TrainingStatus.active;
      case '0':
        return TrainingStatus.inactive;
      case '2':
        return TrainingStatus.cancelled;
      case '3':
        return TrainingStatus.completed;
      default:
        return TrainingStatus.active;
    }
  }
}

enum TrainingSessionStatus {
  scheduled('1'),
  ongoing('2'),
  completed('3'),
  cancelled('4');

  const TrainingSessionStatus(this.value);
  final String value;

  static TrainingSessionStatus fromString(String value) {
    switch (value) {
      case '1':
        return TrainingSessionStatus.scheduled;
      case '2':
        return TrainingSessionStatus.ongoing;
      case '3':
        return TrainingSessionStatus.completed;
      case '4':
        return TrainingSessionStatus.cancelled;
      default:
        return TrainingSessionStatus.scheduled;
    }
  }
}

enum AttendanceStatus {
  absent('0'),
  present('1'),
  late('2'),
  excused('3');

  const AttendanceStatus(this.value);
  final String value;

  static AttendanceStatus fromString(String value) {
    switch (value) {
      case '0':
        return AttendanceStatus.absent;
      case '1':
        return AttendanceStatus.present;
      case '2':
        return AttendanceStatus.late;
      case '3':
        return AttendanceStatus.excused;
      default:
        return AttendanceStatus.absent;
    }
  }

  String get displayName {
    switch (this) {
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.excused:
        return 'Excused';
    }
  }
} 