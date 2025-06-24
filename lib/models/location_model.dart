import 'package:flutter/foundation.dart';

class Location {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? description;

  Location({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    this.description,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id_location']?.toString() ?? '',
      name: json['location_name'] ?? 'Unknown Location',
      address: json['address'] ?? 'No address provided',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': id,
      'location_name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }
} 