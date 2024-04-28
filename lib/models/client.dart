import 'package:bus_location/entities/user.dart';

class Client extends User {
  Client(
      {super.id,
      required super.name,
      required super.lastname,
      required super.email,
      super.type = "client"});

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
        type: map["type"],
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
    };
  }
}
