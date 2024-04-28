import 'package:bus_location/entities/user.dart';

class Admin extends User {
  final String phone;
  final bool isVerified;

  Admin(
      {required this.phone,
      super.id,
      required super.name,
      required super.lastname,
      required super.email,
      this.isVerified = false,
      super.type = "admin"});

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
        type: map["type"],
        isVerified: map["isVerified"],
        phone: map["phone"],
        id: map["id"],
        name: map["name"],
        lastname: map["lastname"],
        email: map["email"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "phone": phone,
      "id": id,
      "name": name,
      "lastname": lastname,
      "email": email,
      "type": type,
      "isVerified": isVerified
    };
  }
}
