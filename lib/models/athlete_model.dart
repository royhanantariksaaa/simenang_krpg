class Athlete {
  final String idAthlete;
  final String idProfile;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? photo;
  final DateTime? birthDate;
  final String? gender;
  final String? bloodType;
  final double? height;
  final double? weight;
  final AthleteLevel? level;
  final AthleteStatus status;
  final String? notes;
  final List<AthleteAchievement>? achievements;
  final List<AthleteSpecialization>? specializations;
  final DateTime? joinDate;
  final DateTime? lastTrainingDate;
  final int? totalTrainings;
  final int? totalCompetitions;
  final int? totalMedals;

  Athlete({
    required this.idAthlete,
    required this.idProfile,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.photo,
    this.birthDate,
    this.gender,
    this.bloodType,
    this.height,
    this.weight,
    this.level,
    this.status = AthleteStatus.active,
    this.notes,
    this.achievements,
    this.specializations,
    this.joinDate,
    this.lastTrainingDate,
    this.totalTrainings,
    this.totalCompetitions,
    this.totalMedals,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      idAthlete: json['id_athlete']?.toString() ?? '',
      idProfile: json['id_profile']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      photo: json['photo'],
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      gender: json['gender'],
      bloodType: json['blood_type'],
      height: json['height'] != null ? double.tryParse(json['height'].toString()) : null,
      weight: json['weight'] != null ? double.tryParse(json['weight'].toString()) : null,
      level: json['level'] != null ? AthleteLevel.fromString(json['level']) : null,
      status: AthleteStatus.fromString(json['status'] ?? 'active'),
      notes: json['notes'],
      achievements: json['achievements'] != null
          ? List<AthleteAchievement>.from(
              json['achievements'].map((x) => AthleteAchievement.fromJson(x)))
          : null,
      specializations: json['specializations'] != null
          ? List<AthleteSpecialization>.from(
              json['specializations'].map((x) => AthleteSpecialization.fromJson(x)))
          : null,
      joinDate: json['join_date'] != null ? DateTime.parse(json['join_date']) : null,
      lastTrainingDate: json['last_training_date'] != null
          ? DateTime.parse(json['last_training_date'])
          : null,
      totalTrainings: json['total_trainings'],
      totalCompetitions: json['total_competitions'],
      totalMedals: json['total_medals'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_athlete': idAthlete,
      'id_profile': idProfile,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'photo': photo,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'blood_type': bloodType,
      'height': height,
      'weight': weight,
      'level': level?.toString(),
      'status': status.toString(),
      'notes': notes,
      'achievements': achievements?.map((x) => x.toJson()).toList(),
      'specializations': specializations?.map((x) => x.toJson()).toList(),
      'join_date': joinDate?.toIso8601String(),
      'last_training_date': lastTrainingDate?.toIso8601String(),
      'total_trainings': totalTrainings,
      'total_competitions': totalCompetitions,
      'total_medals': totalMedals,
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

  String get levelDisplay {
    return level?.displayName ?? '-';
  }

  String get statusDisplay {
    return status.displayName;
  }
}

class AthleteAchievement {
  final String idAchievement;
  final String idAthlete;
  final String title;
  final String? description;
  final DateTime? date;
  final String? place;
  final String? type;
  final String? category;
  final String? image;

  AthleteAchievement({
    required this.idAchievement,
    required this.idAthlete,
    required this.title,
    this.description,
    this.date,
    this.place,
    this.type,
    this.category,
    this.image,
  });

  factory AthleteAchievement.fromJson(Map<String, dynamic> json) {
    return AthleteAchievement(
      idAchievement: json['id_achievement']?.toString() ?? '',
      idAthlete: json['id_athlete']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      place: json['place'],
      type: json['type'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_achievement': idAchievement,
      'id_athlete': idAthlete,
      'title': title,
      'description': description,
      'date': date?.toIso8601String(),
      'place': place,
      'type': type,
      'category': category,
      'image': image,
    };
  }
}

class AthleteSpecialization {
  final String idSpecialization;
  final String idAthlete;
  final String name;
  final String? description;
  final int? level;

  AthleteSpecialization({
    required this.idSpecialization,
    required this.idAthlete,
    required this.name,
    this.description,
    this.level,
  });

  factory AthleteSpecialization.fromJson(Map<String, dynamic> json) {
    return AthleteSpecialization(
      idSpecialization: json['id_specialization']?.toString() ?? '',
      idAthlete: json['id_athlete']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_specialization': idSpecialization,
      'id_athlete': idAthlete,
      'name': name,
      'description': description,
      'level': level,
    };
  }
}

enum AthleteLevel {
  beginner,
  intermediate,
  advanced,
  professional;

  static AthleteLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'beginner':
        return AthleteLevel.beginner;
      case 'intermediate':
        return AthleteLevel.intermediate;
      case 'advanced':
        return AthleteLevel.advanced;
      case 'professional':
        return AthleteLevel.professional;
      default:
        return AthleteLevel.beginner;
    }
  }

  @override
  String toString() {
    switch (this) {
      case AthleteLevel.beginner:
        return 'beginner';
      case AthleteLevel.intermediate:
        return 'intermediate';
      case AthleteLevel.advanced:
        return 'advanced';
      case AthleteLevel.professional:
        return 'professional';
    }
  }

  String get displayName {
    switch (this) {
      case AthleteLevel.beginner:
        return 'Beginner';
      case AthleteLevel.intermediate:
        return 'Intermediate';
      case AthleteLevel.advanced:
        return 'Advanced';
      case AthleteLevel.professional:
        return 'Professional';
    }
  }
}

enum AthleteStatus {
  active,
  inactive,
  suspended,
  retired;

  static AthleteStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return AthleteStatus.active;
      case 'inactive':
        return AthleteStatus.inactive;
      case 'suspended':
        return AthleteStatus.suspended;
      case 'retired':
        return AthleteStatus.retired;
      default:
        return AthleteStatus.active;
    }
  }

  @override
  String toString() {
    switch (this) {
      case AthleteStatus.active:
        return 'active';
      case AthleteStatus.inactive:
        return 'inactive';
      case AthleteStatus.suspended:
        return 'suspended';
      case AthleteStatus.retired:
        return 'retired';
    }
  }

  String get displayName {
    switch (this) {
      case AthleteStatus.active:
        return 'Active';
      case AthleteStatus.inactive:
        return 'Inactive';
      case AthleteStatus.suspended:
        return 'Suspended';
      case AthleteStatus.retired:
        return 'Retired';
    }
  }
} 