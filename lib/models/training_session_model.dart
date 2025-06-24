class TrainingSession {
  final String id;
  final String trainingId;
  final DateTime scheduleDate;
  final String startTime;
  final String endTime;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final TrainingSessionStatus status;
  final DateTime createDate;
  final String createdById;

  // Optional hydrated fields
  final String? trainingTitle;
  final String? coachName;
  final int? attendeeCount;

  TrainingSession({
    required this.id,
    required this.trainingId,
    required this.scheduleDate,
    required this.startTime,
    required this.endTime,
    this.startedAt,
    this.endedAt,
    required this.status,
    required this.createDate,
    required this.createdById,
    this.trainingTitle,
    this.coachName,
    this.attendeeCount,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id_training_session']?.toString() ?? '',
      trainingId: json['id_training']?.toString() ?? '',
      scheduleDate: DateTime.parse(json['schedule_date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      status: TrainingSessionStatus.fromString(json['status'] ?? ''),
      createDate: DateTime.parse(json['create_date'] ?? DateTime.now().toIso8601String()),
      createdById: json['create_id']?.toString() ?? '',
      
      // Hydrated fields
      trainingTitle: json['training_title'],
      coachName: json['coach_name'],
      attendeeCount: json['attendee_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_training_session': id,
      'id_training': trainingId,
      'schedule_date': scheduleDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'status': status.apiValue,
      'create_date': createDate.toIso8601String(),
      'create_id': createdById,
    };
  }

  // Helper getters
  bool get isStarted => startedAt != null;
  bool get isCompleted => endedAt != null;
  Duration? get duration {
    if (startedAt == null || endedAt == null) return null;
    return endedAt!.difference(startedAt!);
  }
}

enum TrainingSessionStatus {
  attendance,
  recording,
  completed;

  static TrainingSessionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'attendance': return TrainingSessionStatus.attendance;
      case 'recording': return TrainingSessionStatus.recording;
      case 'completed': return TrainingSessionStatus.completed;
      default: return TrainingSessionStatus.attendance;
    }
  }

  String get apiValue {
    return toString().split('.').last;
  }

  String get displayName {
    switch (this) {
      case TrainingSessionStatus.attendance: return 'Taking Attendance';
      case TrainingSessionStatus.recording: return 'Recording Performance';
      case TrainingSessionStatus.completed: return 'Completed';
    }
  }
} 