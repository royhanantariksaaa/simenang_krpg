class User {
  final String idAccount;
  final String username;
  final String email;
  final UserRole role;
  final UserStatus status;
  final Profile? profile;
  final DateTime? createdAt;

  User({
    required this.idAccount,
    required this.username,
    required this.email,
    required this.role,
    this.status = UserStatus.active,
    this.profile,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idAccount: json['id_account']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'athlete'),
      status: UserStatus.fromString(json['status']?.toString() ?? 'active'),
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_account': idAccount,
      'username': username,
      'email': email,
      'role': role.value,
      'status': status.value,
      'profile': profile?.toJson(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? idAccount,
    String? username,
    String? email,
    UserRole? role,
    UserStatus? status,
    Profile? profile,
    DateTime? createdAt,
  }) {
    return User(
      idAccount: idAccount ?? this.idAccount,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      profile: profile ?? this.profile,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Profile {
  final String idProfile;
  final String idAccount;
  final String name;
  final String? address;
  final DateTime? birthDate;
  final Gender? gender;
  final String? phoneNumber;
  final String? city;
  final ProfileStatus status;
  final DateTime? joinDate;
  final double? profit;
  final String? profilePicture;
  final String? idClassrooms;
  final String? classroomName;

  Profile({
    required this.idProfile,
    required this.idAccount,
    required this.name,
    this.address,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    this.city,
    this.status = ProfileStatus.active,
    this.joinDate,
    this.profit,
    this.profilePicture,
    this.idClassrooms,
    this.classroomName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      idProfile: json['id_profile']?.toString() ?? '',
      idAccount: json['id_account']?.toString() ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : null,
      gender: json['gender'] != null 
          ? Gender.fromString(json['gender']) 
          : null,
      phoneNumber: json['phone_number'],
      city: json['city'],
      status: ProfileStatus.fromString(json['status']?.toString() ?? '1'),
      joinDate: json['join_date'] != null 
          ? DateTime.parse(json['join_date']) 
          : null,
      profit: json['profit']?.toDouble(),
      profilePicture: json['profile_picture'],
      idClassrooms: json['id_classrooms']?.toString(),
      classroomName: json['classroom_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_profile': idProfile,
      'id_account': idAccount,
      'name': name,
      'address': address,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender?.value,
      'phone_number': phoneNumber,
      'city': city,
      'status': status.value,
      'join_date': joinDate?.toIso8601String(),
      'profit': profit,
      'profile_picture': profilePicture,
      'id_classrooms': idClassrooms,
      'classroom_name': classroomName,
    };
  }
}

enum UserRole {
  leader('leader'),
  coach('coach'),
  athlete('athlete'),
  guest('guest');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'leader':
      case 'admin':
        return UserRole.leader;
      case 'coach':
        return UserRole.coach;
      case 'athlete':
        return UserRole.athlete;
      case 'guest':
        return UserRole.guest;
      default:
        return UserRole.athlete;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.leader:
        return 'Leader';
      case UserRole.coach:
        return 'Coach';
      case UserRole.athlete:
        return 'Athlete';
      case UserRole.guest:
        return 'Guest';
    }
  }
}

enum UserStatus {
  active('1'),
  inactive('0'),
  pending('pending');

  const UserStatus(this.value);
  final String value;

  static UserStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case '1':
      case 'active':
        return UserStatus.active;
      case '0':
      case 'inactive':
        return UserStatus.inactive;
      case 'pending':
        return UserStatus.pending;
      default:
        return UserStatus.active;
    }
  }
}

enum ProfileStatus {
  active('1'),
  inactive('2'),
  pending('3'),
  suspended('4'),
  banned('5'),
  deleted('6');

  const ProfileStatus(this.value);
  final String value;

  static ProfileStatus fromString(String value) {
    switch (value) {
      case '1':
        return ProfileStatus.active;
      case '2':
        return ProfileStatus.inactive;
      case '3':
        return ProfileStatus.pending;
      case '4':
        return ProfileStatus.suspended;
      case '5':
        return ProfileStatus.banned;
      case '6':
        return ProfileStatus.deleted;
      default:
        return ProfileStatus.active;
    }
  }
}

enum Gender {
  male('L'),
  female('P');

  const Gender(this.value);
  final String value;

  static Gender fromString(String value) {
    switch (value.toUpperCase()) {
      case 'L':
      case 'MALE':
        return Gender.male;
      case 'P':
      case 'FEMALE':
        return Gender.female;
      default:
        return Gender.male;
    }
  }

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
} 