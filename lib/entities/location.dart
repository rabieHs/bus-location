// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Location other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}

List<Location> tunisianStates = [
  Location(name: "Ariana", latitude: 36.8663, longitude: 10.1644),
  Location(name: "Beja", latitude: 36.7306, longitude: 9.1865),
  Location(name: "Ben Arous", latitude: 36.7381, longitude: 10.2316),
  Location(name: "Bizerte", latitude: 37.2744, longitude: 9.8737),
  Location(name: "Gabes", latitude: 33.8886, longitude: 10.0982),
  Location(name: "Gafsa", latitude: 34.425, longitude: 8.7843),
  Location(name: "Jendouba", latitude: 36.5008, longitude: 8.7807),
  Location(name: "Kairouan", latitude: 35.6804, longitude: 10.0982),
  Location(name: "Kasserine", latitude: 35.167, longitude: 8.8365),
  Location(name: "Kebili", latitude: 33.7050, longitude: 8.9714),
  Location(name: "Kef", latitude: 36.1756, longitude: 8.7047),
  Location(name: "Mahdia", latitude: 35.5026, longitude: 11.0592),
  Location(name: "Manouba", latitude: 36.8083, longitude: 10.0977),
  Location(name: "Medenine", latitude: 33.3547, longitude: 10.5047),
  Location(name: "Monastir", latitude: 35.7836, longitude: 10.8261),
  Location(name: "Nabeul", latitude: 36.4561, longitude: 10.7351),
  Location(name: "Sfax", latitude: 34.7397, longitude: 10.7592),
  Location(name: "Sidi Bouzid", latitude: 35.0404, longitude: 9.4932),
  Location(name: "Siliana", latitude: 36.0855, longitude: 9.3716),
  Location(name: "Sousse", latitude: 35.8254, longitude: 10.6366),
  Location(name: "Tataouine", latitude: 32.9294, longitude: 10.4514),
  Location(name: "Tozeur", latitude: 33.9194, longitude: 8.1339),
  Location(name: "Tunis", latitude: 36.8065, longitude: 10.1815),
  Location(name: "Zaghouan", latitude: 36.4026, longitude: 10.1477),
];
