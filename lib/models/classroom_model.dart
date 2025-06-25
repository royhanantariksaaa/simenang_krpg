import 'athlete_model.dart';
import 'coach_model.dart';

class Classroom {
  final String id;
  final String name;
  final String coachId;
  final DateTime createdDate;

  // Optional hydrated fields
  final Coach? coach;
  final List<Athlete>? students;
  final int? studentCount;

  Classroom({
    required this.id,
    required this.name,
    required this.coachId,
    required this.createdDate,
    this.coach,
    this.students,
    this.studentCount,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    // Handle both id_classroom and id_classrooms
    final id = json['id_classroom']?.toString() ?? json['id_classrooms']?.toString() ?? '';
    
    return Classroom(
      id: id,
      name: json['classroom_name'] ?? json['name'] ?? '',
      coachId: json['id_coach']?.toString() ?? '',
      createdDate: DateTime.parse(json['create_date'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      
      // Hydrated fields
      coach: json['coach'] != null ? Coach.fromJson(json['coach']) : null,
      students: json['students'] != null
          ? List<Athlete>.from(json['students'].map((x) => Athlete.fromJson(x)))
          : null,
      studentCount: json['student_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_classrooms': id,
      'classroom_name': name,
      'id_coach': coachId,
      'create_date': createdDate.toIso8601String(),
    };
  }
} 