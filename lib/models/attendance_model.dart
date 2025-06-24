import 'package:flutter/material.dart';
import '../../design_system/krpg_theme.dart';

class Attendance {
  final String id;
  final String profileId;
  final String trainingSessionId;
  final AttendanceStatus status;
  final DateTime dateTime;
  final String? note;

  // Optional hydrated fields
  final String? athleteName;
  final String? trainingTitle;

  Attendance({
    required this.id,
    required this.profileId,
    required this.trainingSessionId,
    required this.status,
    required this.dateTime,
    this.note,
    this.athleteName,
    this.trainingTitle,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id_attendance']?.toString() ?? '',
      profileId: json['id_profile']?.toString() ?? '',
      trainingSessionId: json['id_training_session']?.toString() ?? '',
      status: AttendanceStatus.fromString(json['status']?.toString() ?? '1'),
      dateTime: DateTime.parse(json['date_time'] ?? DateTime.now().toIso8601String()),
      note: json['note'],
      
      // Hydrated fields
      athleteName: json['athlete_name'],
      trainingTitle: json['training_title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_attendance': id,
      'id_profile': profileId,
      'id_training_session': trainingSessionId,
      'status': status.apiValue,
      'date_time': dateTime.toIso8601String(),
      'note': note,
    };
  }
}

enum AttendanceStatus {
  present,
  late,
  excused,
  absent;

  static AttendanceStatus fromString(String value) {
    switch (value) {
      case '1': return AttendanceStatus.present;
      case '2': return AttendanceStatus.late;
      case '3': return AttendanceStatus.excused;
      case '4': return AttendanceStatus.absent;
      default: return AttendanceStatus.absent;
    }
  }

  String get apiValue {
    switch (this) {
      case AttendanceStatus.present: return '1';
      case AttendanceStatus.late: return '2';
      case AttendanceStatus.excused: return '3';
      case AttendanceStatus.absent: return '4';
    }
  }

  String get displayName {
    switch (this) {
      case AttendanceStatus.present: return 'Present';
      case AttendanceStatus.late: return 'Late';
      case AttendanceStatus.excused: return 'Excused';
      case AttendanceStatus.absent: return 'Absent';
    }
  }

  Color get displayColor {
    switch (this) {
      case AttendanceStatus.present: return KRPGTheme.successColor;
      case AttendanceStatus.late: return KRPGTheme.warningColor;
      case AttendanceStatus.excused: return KRPGTheme.infoColor;
      case AttendanceStatus.absent: return KRPGTheme.dangerColor;
    }
  }

  IconData get displayIcon {
    switch (this) {
      case AttendanceStatus.present: return Icons.check_circle_outline_rounded;
      case AttendanceStatus.late: return Icons.watch_later_outlined;
      case AttendanceStatus.excused: return Icons.info_outline_rounded;
      case AttendanceStatus.absent: return Icons.cancel_outlined;
    }
  }
} 