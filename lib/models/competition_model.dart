class Competition {
  final String idCompetition;
  final String competitionName;
  final String? organizer;
  final CompetitionLevel? competitionLevel;
  final AthleteLevel? athleteLevel;
  final CompetitionStatus status;
  final String? location;
  final String? link;
  final String? contactPerson;
  final String? description;
  final String? image;
  final String? prize;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? startRegisterTime;
  final DateTime? endRegisterTime;
  final DateTime? createDate;
  final String? createId;
  final List<CompetitionParticipant>? participants;

  Competition({
    required this.idCompetition,
    required this.competitionName,
    this.organizer,
    this.competitionLevel,
    this.athleteLevel,
    this.status = CompetitionStatus.comingSoon,
    this.location,
    this.link,
    this.contactPerson,
    this.description,
    this.image,
    this.prize,
    this.startTime,
    this.endTime,
    this.startRegisterTime,
    this.endRegisterTime,
    this.createDate,
    this.createId,
    this.participants,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      idCompetition: json['id_competition']?.toString() ?? '',
      competitionName: json['competition_name'] ?? '',
      organizer: json['organizer'],
      competitionLevel: json['competition_level'] != null 
          ? CompetitionLevel.fromString(json['competition_level']) 
          : null,
      athleteLevel: json['athlete_level'] != null 
          ? AthleteLevel.fromString(json['athlete_level']) 
          : null,
      status: CompetitionStatus.fromString(json['status']?.toString() ?? '1'),
      location: json['location'],
      link: json['link'],
      contactPerson: json['contact_person'],
      description: json['description'],
      image: json['image'],
      prize: json['prize'],
      startTime: json['start_time'] != null 
          ? DateTime.parse(json['start_time']) 
          : null,
      endTime: json['end_time'] != null 
          ? DateTime.parse(json['end_time']) 
          : null,
      startRegisterTime: json['start_register_time'] != null 
          ? DateTime.parse(json['start_register_time']) 
          : null,
      endRegisterTime: json['end_register_time'] != null 
          ? DateTime.parse(json['end_register_time']) 
          : null,
      createDate: json['create_date'] != null 
          ? DateTime.parse(json['create_date']) 
          : null,
      createId: json['create_id']?.toString(),
      participants: json['participants'] != null 
          ? (json['participants'] as List).map((p) => CompetitionParticipant.fromJson(p)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_competition': idCompetition,
      'competition_name': competitionName,
      'organizer': organizer,
      'competition_level': competitionLevel?.value,
      'athlete_level': athleteLevel?.value,
      'status': status.value,
      'location': location,
      'link': link,
      'contact_person': contactPerson,
      'description': description,
      'image': image,
      'prize': prize,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'start_register_time': startRegisterTime?.toIso8601String(),
      'end_register_time': endRegisterTime?.toIso8601String(),
      'create_date': createDate?.toIso8601String(),
      'create_id': createId,
      'participants': participants?.map((p) => p.toJson()).toList(),
    };
  }

  bool get isRegistrationOpen {
    final now = DateTime.now();
    if (startRegisterTime != null && endRegisterTime != null) {
      return now.isAfter(startRegisterTime!) && now.isBefore(endRegisterTime!);
    }
    return false;
  }

  String get formattedDate {
    if (startTime != null && endTime != null) {
      if (startTime!.day == endTime!.day) {
        return '${startTime!.day}/${startTime!.month}/${startTime!.year}';
      } else {
        return '${startTime!.day}/${startTime!.month} - ${endTime!.day}/${endTime!.month}/${endTime!.year}';
      }
    }
    return 'TBA';
  }
}

class CompetitionParticipant {
  final String idParticipant;
  final String idCompetition;
  final String idProfile;
  final ParticipantStatus status;
  final DateTime? registrationDate;
  final String? notes;
  final String? athleteName;
  final CompetitionResult? result;

  CompetitionParticipant({
    required this.idParticipant,
    required this.idCompetition,
    required this.idProfile,
    this.status = ParticipantStatus.pending,
    this.registrationDate,
    this.notes,
    this.athleteName,
    this.result,
  });

  factory CompetitionParticipant.fromJson(Map<String, dynamic> json) {
    return CompetitionParticipant(
      idParticipant: json['id_participant']?.toString() ?? '',
      idCompetition: json['id_competition']?.toString() ?? '',
      idProfile: json['id_profile']?.toString() ?? '',
      status: ParticipantStatus.fromString(json['status']?.toString() ?? '0'),
      registrationDate: json['registration_date'] != null 
          ? DateTime.parse(json['registration_date']) 
          : null,
      notes: json['notes'],
      athleteName: json['athlete_name'],
      result: json['result'] != null ? CompetitionResult.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_participant': idParticipant,
      'id_competition': idCompetition,
      'id_profile': idProfile,
      'status': status.value,
      'registration_date': registrationDate?.toIso8601String(),
      'notes': notes,
      'athlete_name': athleteName,
      'result': result?.toJson(),
    };
  }
}

class CompetitionResult {
  final String idResult;
  final String idCompetition;
  final String idProfile;
  final int position;
  final String? time;
  final String? score;
  final String? notes;
  final String? certificateUrl;

  CompetitionResult({
    required this.idResult,
    required this.idCompetition,
    required this.idProfile,
    required this.position,
    this.time,
    this.score,
    this.notes,
    this.certificateUrl,
  });

  factory CompetitionResult.fromJson(Map<String, dynamic> json) {
    return CompetitionResult(
      idResult: json['id_result']?.toString() ?? '',
      idCompetition: json['id_competition']?.toString() ?? '',
      idProfile: json['id_profile']?.toString() ?? '',
      position: json['position']?.toInt() ?? 0,
      time: json['time'],
      score: json['score'],
      notes: json['notes'],
      certificateUrl: json['certificate_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_result': idResult,
      'id_competition': idCompetition,
      'id_profile': idProfile,
      'position': position,
      'time': time,
      'score': score,
      'notes': notes,
      'certificate_url': certificateUrl,
    };
  }

  String get positionText {
    switch (position) {
      case 1:
        return '1st Place 🥇';
      case 2:
        return '2nd Place 🥈';
      case 3:
        return '3rd Place 🥉';
      default:
        return '${position}th Place';
    }
  }
}

enum CompetitionStatus {
  comingSoon('1'),
  ongoing('2'),
  finished('3'),
  cancelled('4'),
  inactive('5');

  const CompetitionStatus(this.value);
  final String value;

  static CompetitionStatus fromString(String value) {
    switch (value) {
      case '1':
        return CompetitionStatus.comingSoon;
      case '2':
        return CompetitionStatus.ongoing;
      case '3':
        return CompetitionStatus.finished;
      case '4':
        return CompetitionStatus.cancelled;
      case '5':
        return CompetitionStatus.inactive;
      default:
        return CompetitionStatus.comingSoon;
    }
  }

  String get displayName {
    switch (this) {
      case CompetitionStatus.comingSoon:
        return 'Coming Soon';
      case CompetitionStatus.ongoing:
        return 'Ongoing';
      case CompetitionStatus.finished:
        return 'Finished';
      case CompetitionStatus.cancelled:
        return 'Cancelled';
      case CompetitionStatus.inactive:
        return 'Inactive';
    }
  }
}

enum CompetitionLevel {
  local('local'),
  regional('regional'),
  national('national'),
  international('international');

  const CompetitionLevel(this.value);
  final String value;

  static CompetitionLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'local':
        return CompetitionLevel.local;
      case 'regional':
        return CompetitionLevel.regional;
      case 'national':
        return CompetitionLevel.national;
      case 'international':
        return CompetitionLevel.international;
      default:
        return CompetitionLevel.local;
    }
  }

  String get displayName {
    switch (this) {
      case CompetitionLevel.local:
        return 'Local';
      case CompetitionLevel.regional:
        return 'Regional';
      case CompetitionLevel.national:
        return 'National';
      case CompetitionLevel.international:
        return 'International';
    }
  }
}

enum AthleteLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced'),
  professional('professional');

  const AthleteLevel(this.value);
  final String value;

  static AthleteLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'beginner':
        return AthleteLevel.beginner;
      case 'intermediate':
        return AthleteLevel.intermediate;
      case 'advanced':
        return AthleteLevel.advanced;
      case 'professional':
        return AthleteLevel.professional;
      default:
        return AthleteLevel.beginner;
    }
  }

  String get displayName {
    switch (this) {
      case AthleteLevel.beginner:
        return 'Beginner';
      case AthleteLevel.intermediate:
        return 'Intermediate';
      case AthleteLevel.advanced:
        return 'Advanced';
      case AthleteLevel.professional:
        return 'Professional';
    }
  }
}

enum ParticipantStatus {
  pending('0'),
  approved('1'),
  rejected('2'),
  waitingDelegate('3');

  const ParticipantStatus(this.value);
  final String value;

  static ParticipantStatus fromString(String value) {
    switch (value) {
      case '0':
        return ParticipantStatus.pending;
      case '1':
        return ParticipantStatus.approved;
      case '2':
        return ParticipantStatus.rejected;
      case '3':
        return ParticipantStatus.waitingDelegate;
      default:
        return ParticipantStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case ParticipantStatus.pending:
        return 'Pending';
      case ParticipantStatus.approved:
        return 'Approved';
      case ParticipantStatus.rejected:
        return 'Rejected';
      case ParticipantStatus.waitingDelegate:
        return 'Waiting Delegate';
    }
  }
} 