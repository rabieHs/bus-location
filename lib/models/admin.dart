import 'package:bus_location/entities/user.dart';

class Admin extends User {
  final String phone;

  Admin(
      {required this.phone,
      required super.id,
      required super.name,
      required super.lastname,
      required super.email,
      super.type = "admin"});
}
