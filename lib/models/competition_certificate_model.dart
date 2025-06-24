class CompetitionCertificate {
  final String id;
  final String registeredParticipantId;
  final CertificateType certificateType;
  final String certificatePath;
  final String? notes;
  final DateTime uploadDate;
  final String uploadedById;
  final bool isDeleted;

  // Optional hydrated fields
  final String? athleteName;
  final String? competitionName;
  final DateTime? competitionDate;
  final String? uploaderName;

  CompetitionCertificate({
    required this.id,
    required this.registeredParticipantId,
    required this.certificateType,
    required this.certificatePath,
    this.notes,
    required this.uploadDate,
    required this.uploadedById,
    this.isDeleted = false,
    this.athleteName,
    this.competitionName,
    this.competitionDate,
    this.uploaderName,
  });

  factory CompetitionCertificate.fromJson(Map<String, dynamic> json) {
    return CompetitionCertificate(
      id: json['id_certificate']?.toString() ?? '',
      registeredParticipantId: json['id_registered_participant_competition']?.toString() ?? '',
      certificateType: CertificateType.fromString(json['certificate_type'] ?? ''),
      certificatePath: json['certificate_path'] ?? '',
      notes: json['notes'],
      uploadDate: DateTime.parse(json['upload_date'] ?? DateTime.now().toIso8601String()),
      uploadedById: json['uploaded_by']?.toString() ?? '',
      isDeleted: json['delete_YN'] == 'Y',
      
      // Hydrated fields
      athleteName: json['athlete_name'],
      competitionName: json['competition_name'],
      competitionDate: json['competition_date'] != null 
          ? DateTime.parse(json['competition_date']) 
          : null,
      uploaderName: json['uploader_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_certificate': id,
      'id_registered_participant_competition': registeredParticipantId,
      'certificate_type': certificateType.apiValue,
      'certificate_path': certificatePath,
      'notes': notes,
      'upload_date': uploadDate.toIso8601String(),
      'uploaded_by': uploadedById,
      'delete_YN': isDeleted ? 'Y' : 'N',
    };
  }

  // Helper getters
  String get displayType => certificateType.displayName;
  String get displayAthlete => athleteName ?? 'Athlete ID: $registeredParticipantId';
  String get displayUploader => uploaderName ?? 'Uploader ID: $uploadedById';
  String get displayCompetition => competitionName ?? 'Competition Certificate';
}

enum CertificateType {
  participation,
  achievement,
  winner;

  static CertificateType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'participation': return CertificateType.participation;
      case 'achievement': return CertificateType.achievement;
      case 'winner': return CertificateType.winner;
      default: return CertificateType.participation;
    }
  }

  String get apiValue => toString().split('.').last;

  String get displayName {
    switch (this) {
      case CertificateType.participation: return 'Certificate of Participation';
      case CertificateType.achievement: return 'Certificate of Achievement';
      case CertificateType.winner: return 'Winner Certificate';
    }
  }
} 