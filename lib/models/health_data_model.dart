class HealthData {
  final String? id;
  final String profileId;
  final double? height;
  final double? weight;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? diseaseHistory;
  final DateTime? lastUpdated;

  HealthData({
    this.id,
    required this.profileId,
    this.height,
    this.weight,
    this.bloodType,
    this.allergies,
    this.diseaseHistory,
    this.lastUpdated,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      id: json['id_health']?.toString(),
      profileId: json['id_profile']?.toString() ?? '',
      height: double.tryParse(json['height']?.toString() ?? ''),
      weight: double.tryParse(json['weight']?.toString() ?? ''),
      bloodType: json['bloodType'],
      allergies: json['allergies'] != null ? List<String>.from(json['allergies']) : null,
      diseaseHistory: json['disease_history'] != null 
          ? List<String>.from(json['disease_history']) 
          : null,
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_health': id,
      'id_profile': profileId,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'allergies': allergies,
      'disease_history': diseaseHistory,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  double? get bmi {
    if (height == null || weight == null || height == 0) {
      return null;
    }
    // Height is assumed to be in cm, convert to meters for BMI calculation
    return weight! / ((height! / 100) * (height! / 100));
  }
} 