class RegisteredParticipant {
  final String id;
  final String trainingId;
  final String profileId;
  final String coachId;
  final String? classroomId;
  final DateTime registrationDate;
  final bool isDeleted;

  // Optional hydrated fields
  final String? athleteName;
  final String? coachName;
  final String? trainingTitle;
  final String? classroomName;

  RegisteredParticipant({
    required this.id,
    required this.trainingId,
    required this.profileId,
    required this.coachId,
    this.classroomId,
    required this.registrationDate,
    this.isDeleted = false,
    this.athleteName,
    this.coachName,
    this.trainingTitle,
    this.classroomName,
  });

  factory RegisteredParticipant.fromJson(Map<String, dynamic> json) {
    return RegisteredParticipant(
      id: json['id_registered']?.toString() ?? '',
      trainingId: json['id_training']?.toString() ?? '',
      profileId: json['id_profile']?.toString() ?? '',
      coachId: json['id_coach']?.toString() ?? '',
      classroomId: json['id_classroom']?.toString(),
      registrationDate: DateTime.parse(json['registration_date'] ?? DateTime.now().toIso8601String()),
      isDeleted: json['delete_YN'] == 'Y',
      
      // Hydrated fields
      athleteName: json['athlete_name'],
      coachName: json['coach_name'],
      trainingTitle: json['training_title'],
      classroomName: json['classroom_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_registered': id,
      'id_training': trainingId,
      'id_profile': profileId,
      'id_coach': coachId,
      'id_classroom': classroomId,
      'registration_date': registrationDate.toIso8601String(),
      'delete_YN': isDeleted ? 'Y' : 'N',
    };
  }

  // Helper getters
  bool get isClassroomTraining => classroomId != null;
  String get displayName => athleteName ?? 'Athlete #$profileId';
  String get displayTraining => trainingTitle ?? 'Training #$trainingId';
  String get displayCoach => coachName ?? 'Coach #$coachId';
  String get displayClassroom => classroomName ?? (classroomId != null ? 'Classroom #$classroomId' : 'Individual Training');
} 