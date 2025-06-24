class TrainingPhase {
  final String id;
  final String phaseName;
  final String? description;
  final int durationWeeks;
  final bool isDeleted;

  // Optional hydrated fields
  final int? activeTrainings;
  final DateTime? startDate;
  final DateTime? endDate;

  TrainingPhase({
    required this.id,
    required this.phaseName,
    this.description,
    required this.durationWeeks,
    this.isDeleted = false,
    this.activeTrainings,
    this.startDate,
    this.endDate,
  });

  factory TrainingPhase.fromJson(Map<String, dynamic> json) {
    return TrainingPhase(
      id: json['id_training_phase']?.toString() ?? '',
      phaseName: json['phase_name'] ?? '',
      description: json['description'],
      durationWeeks: int.tryParse(json['duration_weeks']?.toString() ?? '') ?? 0,
      isDeleted: json['delete_YN'] == 'Y',
      
      // Hydrated fields
      activeTrainings: int.tryParse(json['active_trainings']?.toString() ?? ''),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_training_phase': id,
      'phase_name': phaseName,
      'description': description,
      'duration_weeks': durationWeeks,
      'delete_YN': isDeleted ? 'Y' : 'N',
    };
  }

  // Helper getters
  bool get isActive {
    if (startDate == null || endDate == null) return false;
    final now = DateTime.now();
    return now.isAfter(startDate!) && now.isBefore(endDate!);
  }

  double get progressPercentage {
    if (startDate == null || endDate == null) return 0;
    final now = DateTime.now();
    if (now.isBefore(startDate!)) return 0;
    if (now.isAfter(endDate!)) return 100;
    
    final totalDuration = endDate!.difference(startDate!).inDays;
    final elapsed = now.difference(startDate!).inDays;
    return (elapsed / totalDuration * 100).clamp(0, 100);
  }

  String get durationDisplay {
    if (durationWeeks < 1) return 'Less than a week';
    if (durationWeeks == 1) return '1 week';
    return '$durationWeeks weeks';
  }
} 