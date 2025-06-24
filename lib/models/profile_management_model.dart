import 'package:simenang_krpg/models/user_model.dart';

class ProfileManagement {
  final String id;
  final String accountId;
  final String name;
  final DateTime birthDate;
  final Gender gender;
  final String? phone;
  final String? address;
  final String? profilePictureUrl;
  final String? classroomId;
  final ProfileStatus status;

  ProfileManagement({
    required this.id,
    required this.accountId,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.phone,
    this.address,
    this.profilePictureUrl,
    this.classroomId,
    required this.status,
  });

  factory ProfileManagement.fromJson(Map<String, dynamic> json) {
    return ProfileManagement(
      id: json['id_profile']?.toString() ?? '',
      accountId: json['id_account']?.toString() ?? '',
      name: json['name'] ?? 'No Name',
      birthDate: DateTime.parse(json['birth_date']),
      gender: Gender.fromString(json['gender'] ?? 'L'),
      phone: json['phone'],
      address: json['address'],
      profilePictureUrl: json['profile_picture'],
      classroomId: json['id_classrooms']?.toString(),
      status: ProfileStatus.fromString(json['status'] ?? '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_profile': id,
      'id_account': accountId,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender.value,
      'phone': phone,
      'address': address,
      'profile_picture': profilePictureUrl,
      'id_classrooms': classroomId,
      'status': status.value,
    };
  }

  // Helper getters
  bool get isActive => status == ProfileStatus.active;
  String get statusDisplay => status.value;
  String get genderDisplay => gender == Gender.male ? 'Male' : 'Female';
  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
} 