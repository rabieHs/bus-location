import 'package:bus_location/entities/user.dart';

class Driver extends User {
  final bool isVerified;
  Driver({
    this.isVerified = false,
    super.id,
    required super.name,
    required super.lastname,
    required super.email,
    super.type = "driver",
  });

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
        type: map["type"],
        isVerified: map["isVerified"],
        id: map["id"],
        name: map["name"],
        lastname: map["lastname"],
        email: map["email"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "lastname": lastname,
      "email": email,
      "type": type,
      "isVerified": isVerified
    };
  }
}
