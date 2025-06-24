class Coach {
  final String idCoach;
  final String idProfile;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? photo;
  final DateTime? birthDate;
  final String? gender;
  final String? specialization;
  final List<String>? certifications;
  final String? experience;
  final CoachStatus status;
  final String? notes;
  final DateTime? joinDate;
  final int? totalTrainings;
  final int? totalAthletes;
  final List<CoachSchedule>? schedules;

  Coach({
    required this.idCoach,
    required this.idProfile,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.photo,
    this.birthDate,
    this.gender,
    this.specialization,
    this.certifications,
    this.experience,
    this.status = CoachStatus.active,
    this.notes,
    this.joinDate,
    this.totalTrainings,
    this.totalAthletes,
    this.schedules,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      idCoach: json['id_coach']?.toString() ?? '',
      idProfile: json['id_profile']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      photo: json['photo'],
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      gender: json['gender'],
      specialization: json['specialization'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      experience: json['experience'],
      status: CoachStatus.fromString(json['status'] ?? 'active'),
      notes: json['notes'],
      joinDate: json['join_date'] != null ? DateTime.parse(json['join_date']) : null,
      totalTrainings: json['total_trainings'],
      totalAthletes: json['total_athletes'],
      schedules: json['schedules'] != null
          ? List<CoachSchedule>.from(
              json['schedules'].map((x) => CoachSchedule.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_coach': idCoach,
      'id_profile': idProfile,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'photo': photo,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'specialization': specialization,
      'certifications': certifications,
      'experience': experience,
      'status': status.toString(),
      'notes': notes,
      'join_date': joinDate?.toIso8601String(),
      'total_trainings': totalTrainings,
      'total_athletes': totalAthletes,
      'schedules': schedules?.map((x) => x.toJson()).toList(),
    };
  }

  String get formattedBirthDate {
    if (birthDate == null) return '-';
    return '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}';
  }

  String get formattedJoinDate {
    if (joinDate == null) return '-';
    return '${joinDate!.day}/${joinDate!.month}/${joinDate!.year}';
  }

  String get age {
    if (birthDate == null) return '-';
    final now = DateTime.now();
    int years = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      years--;
    }
    return '$years';
  }

  String get statusDisplay {
    return status.displayName;
  }

  bool get isAvailable {
    return status == CoachStatus.active;
  }
}

class CoachSchedule {
  final String idSchedule;
  final String idCoach;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final bool isRecurring;
  final DateTime? specificDate;
  final String? notes;
  final bool isAvailable;

  CoachSchedule({
    required this.idSchedule,
    required this.idCoach,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.isRecurring = true,
    this.specificDate,
    this.notes,
    this.isAvailable = true,
  });

  factory CoachSchedule.fromJson(Map<String, dynamic> json) {
    return CoachSchedule(
      idSchedule: json['id_schedule']?.toString() ?? '',
      idCoach: json['id_coach']?.toString() ?? '',
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isRecurring: json['is_recurring'] ?? true,
      specificDate: json['specific_date'] != null
          ? DateTime.parse(json['specific_date'])
          : null,
      notes: json['notes'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_schedule': idSchedule,
      'id_coach': idCoach,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_recurring': isRecurring,
      'specific_date': specificDate?.toIso8601String(),
      'notes': notes,
      'is_available': isAvailable,
    };
  }

  String get formattedTimeRange {
    if (startTime == null || endTime == null) return '-';
    return '$startTime - $endTime';
  }

  String get formattedDay {
    if (isRecurring && dayOfWeek != null) {
      return dayOfWeek!;
    } else if (!isRecurring && specificDate != null) {
      return '${specificDate!.day}/${specificDate!.month}/${specificDate!.year}';
    }
    return '-';
  }
}

enum CoachStatus {
  active,
  inactive,
  onLeave,
  retired;

  static CoachStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return CoachStatus.active;
      case 'inactive':
        return CoachStatus.inactive;
      case 'on_leave':
      case 'onleave':
      case 'on leave':
        return CoachStatus.onLeave;
      case 'retired':
        return CoachStatus.retired;
      default:
        return CoachStatus.active;
    }
  }

  @override
  String toString() {
    switch (this) {
      case CoachStatus.active:
        return 'active';
      case CoachStatus.inactive:
        return 'inactive';
      case CoachStatus.onLeave:
        return 'on_leave';
      case CoachStatus.retired:
        return 'retired';
    }
  }

  String get displayName {
    switch (this) {
      case CoachStatus.active:
        return 'Active';
      case CoachStatus.inactive:
        return 'Inactive';
      case CoachStatus.onLeave:
        return 'On Leave';
      case CoachStatus.retired:
        return 'Retired';
    }
  }
} 