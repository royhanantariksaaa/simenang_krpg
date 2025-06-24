class CompetitionResult {
  final String id;
  final String registeredParticipantId;
  final int? position;
  final String? timeResult;
  final double? points;
  final CompetitionResultStatus resultStatus;
  final CompetitionResultType resultType;
  final String? category;
  final String? notes;
  final DateTime createDate;
  final String createdById;

  // Optional hydrated fields
  final String? athleteName;
  final String? competitionName;
  final DateTime? competitionDate;

  CompetitionResult({
    required this.id,
    required this.registeredParticipantId,
    this.position,
    this.timeResult,
    this.points,
    required this.resultStatus,
    required this.resultType,
    this.category,
    this.notes,
    required this.createDate,
    required this.createdById,
    this.athleteName,
    this.competitionName,
    this.competitionDate,
  });

  factory CompetitionResult.fromJson(Map<String, dynamic> json) {
    return CompetitionResult(
      id: json['id_result']?.toString() ?? '',
      registeredParticipantId: json['id_registered_participant_competition']?.toString() ?? '',
      position: int.tryParse(json['position']?.toString() ?? ''),
      timeResult: json['time_result'],
      points: double.tryParse(json['points']?.toString() ?? ''),
      resultStatus: CompetitionResultStatus.fromString(json['result_status'] ?? ''),
      resultType: CompetitionResultType.fromString(json['result_type'] ?? ''),
      category: json['category'],
      notes: json['notes'],
      createDate: DateTime.parse(json['create_date'] ?? DateTime.now().toIso8601String()),
      createdById: json['create_id']?.toString() ?? '',
      
      // Hydrated fields
      athleteName: json['athlete_name'],
      competitionName: json['competition_name'],
      competitionDate: json['competition_date'] != null 
          ? DateTime.parse(json['competition_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_result': id,
      'id_registered_participant_competition': registeredParticipantId,
      'position': position,
      'time_result': timeResult,
      'points': points,
      'result_status': resultStatus.apiValue,
      'result_type': resultType.apiValue,
      'category': category,
      'notes': notes,
      'create_date': createDate.toIso8601String(),
      'create_id': createdById,
    };
  }

  // Helper getters
  bool get isCompleted => resultStatus == CompetitionResultStatus.completed;
  bool get isFinal => resultType == CompetitionResultType.final_;
  Duration? get duration {
    if (timeResult == null) return null;
    try {
      final parts = timeResult!.split(':');
      if (parts.length == 3) {
        return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]),
        );
      } else if (parts.length == 2) {
        return Duration(
          minutes: int.parse(parts[0]),
          seconds: int.parse(parts[1]),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

enum CompetitionResultStatus {
  dns,
  dnf,
  dq,
  completed;

  static CompetitionResultStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'dns': return CompetitionResultStatus.dns;
      case 'dnf': return CompetitionResultStatus.dnf;
      case 'dq': return CompetitionResultStatus.dq;
      case 'completed': return CompetitionResultStatus.completed;
      default: return CompetitionResultStatus.dns;
    }
  }

  String get apiValue => toString().split('.').last.toUpperCase();

  String get displayName {
    switch (this) {
      case CompetitionResultStatus.dns: return 'Did Not Start';
      case CompetitionResultStatus.dnf: return 'Did Not Finish';
      case CompetitionResultStatus.dq: return 'Disqualified';
      case CompetitionResultStatus.completed: return 'Completed';
    }
  }
}

enum CompetitionResultType {
  preliminary,
  final_;

  static CompetitionResultType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'preliminary': return CompetitionResultType.preliminary;
      case 'final': return CompetitionResultType.final_;
      default: return CompetitionResultType.preliminary;
    }
  }

  String get apiValue => toString().split('.').last.replaceAll('_', '');

  String get displayName {
    switch (this) {
      case CompetitionResultType.preliminary: return 'Preliminary';
      case CompetitionResultType.final_: return 'Final';
    }
  }
} 