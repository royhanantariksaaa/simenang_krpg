class RegisteredParticipantTraining {
  final String id;
  final String trainingId;
  final String profileId;
  final String coachId;
  final String? classroomId;
  final DateTime registrationDate;

  RegisteredParticipantTraining({
    required this.id,
    required this.trainingId,
    required this.profileId,
    required this.coachId,
    this.classroomId,
    required this.registrationDate,
  });

  factory RegisteredParticipantTraining.fromJson(Map<String, dynamic> json) {
    return RegisteredParticipantTraining(
      id: json['id_registered']?.toString() ?? '',
      trainingId: json['id_training']?.toString() ?? '',
      profileId: json['id_profile']?.toString() ?? '',
      coachId: json['id_coach']?.toString() ?? '',
      classroomId: json['id_classroom']?.toString(),
      registrationDate: DateTime.parse(json['registration_date']),
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
    };
  }
} 