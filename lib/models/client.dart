import 'package:bus_location/entities/user.dart';

class Client extends User {
  Client(
      {required super.id,
      required super.name,
      required super.lastname,
      required super.email,
      super.type = "client"});
}
