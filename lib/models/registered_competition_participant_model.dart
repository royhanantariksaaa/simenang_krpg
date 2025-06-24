class RegisteredCompetitionParticipant {
  final String id;
  final String competitionId;
  final String profileId;
  final RegistrationStatus status;
  final String? note;
  final DateTime createdAt;
  final String createdBy;

  RegisteredCompetitionParticipant({
    required this.id,
    required this.competitionId,
    required this.profileId,
    required this.status,
    this.note,
    required this.createdAt,
    required this.createdBy,
  });

  factory RegisteredCompetitionParticipant.fromJson(Map<String, dynamic> json) {
    return RegisteredCompetitionParticipant(
      id: json['id_registered_participant_competition']?.toString() ?? '',
      competitionId: json['id_competition']?.toString() ?? '',
      profileId: json['id_profile']?.toString() ?? '',
      status: RegistrationStatus.fromString(json['status'] ?? 'pending'),
      note: json['note'],
      createdAt: DateTime.parse(json['create_date']),
      createdBy: json['create_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_registered_participant_competition': id,
      'id_competition': competitionId,
      'id_profile': profileId,
      'status': status.value,
      'note': note,
      'create_date': createdAt.toIso8601String(),
      'create_id': createdBy,
    };
  }
}

enum RegistrationStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  withdrawn('withdrawn');

  const RegistrationStatus(this.value);
  final String value;

  static RegistrationStatus fromString(String value) {
    return RegistrationStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => RegistrationStatus.pending,
    );
  }
} 