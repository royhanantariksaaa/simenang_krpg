class TrainingStatistics {
  final String id;
  final String attendanceId;
  final String profileId;
  final String stroke;
  final String? duration;
  final String? distance;
  final String energySystem;
  final String? note;
  final bool isDeleted;

  // Optional hydrated fields
  final String? athleteName;
  final DateTime? trainingDate;
  final String? trainingTitle;

  TrainingStatistics({
    required this.id,
    required this.attendanceId,
    required this.profileId,
    required this.stroke,
    this.duration,
    this.distance,
    required this.energySystem,
    this.note,
    this.isDeleted = false,
    this.athleteName,
    this.trainingDate,
    this.trainingTitle,
  });

  factory TrainingStatistics.fromJson(Map<String, dynamic> json) {
    return TrainingStatistics(
      id: json['id_statistic']?.toString() ?? '',
      attendanceId: json['id_attendance']?.toString() ?? '',
      profileId: json['id_profile']?.toString() ?? '',
      stroke: json['stroke'] ?? '',
      duration: json['duration'],
      distance: json['distance'],
      energySystem: json['energy_system'] ?? '',
      note: json['note'],
      isDeleted: json['delete_YN'] == 'Y',
      
      // Hydrated fields
      athleteName: json['athlete_name'],
      trainingDate: json['training_date'] != null 
          ? DateTime.parse(json['training_date']) 
          : null,
      trainingTitle: json['training_title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_statistic': id,
      'id_attendance': attendanceId,
      'id_profile': profileId,
      'stroke': stroke,
      'duration': duration,
      'distance': distance,
      'energy_system': energySystem,
      'note': note,
      'delete_YN': isDeleted ? 'Y' : 'N',
    };
  }

  // Helper getters
  double? get distanceInMeters {
    if (distance == null) return null;
    try {
      return double.parse(distance!);
    } catch (_) {
      return null;
    }
  }

  Duration? get durationInSeconds {
    if (duration == null) return null;
    try {
      final parts = duration!.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  double? get pace {
    if (distanceInMeters == null || durationInSeconds == null) return null;
    return (durationInSeconds!.inSeconds / 60) / (distanceInMeters! / 100);
  }
}

enum EnergySystem {
  aerobic11('aerobic_11'),
  aerobic12('aerobic_12'),
  aerobic13('aerobic_13'),
  aerobic21('aerobic_21'),
  aerobic22('aerobic_22'),
  aerobic31('aerobic_31'),
  aerobic32('aerobic_32'),
  vo2max11('vo2max_11'),
  vo2max12('vo2max_12'),
  anaerobic11('anaerobic_11'),
  anaerobic12('anaerobic_12'),
  anaerobic21('anaerobic_21'),
  anaerobic22('anaerobic_22'),
  unknown('unknown');

  const EnergySystem(this.value);
  final String value;

  static EnergySystem fromString(String value) {
    return EnergySystem.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EnergySystem.unknown,
    );
  }
} 