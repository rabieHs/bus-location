import 'package:bus_location/entities/user.dart';

class Driver extends User {
  Driver({
    required super.id,
    required super.name,
    required super.lastname,
    required super.email,
    super.type = "driver",
  });
}

// user type 
/// client => client
/// admin ==> admin
/// driver