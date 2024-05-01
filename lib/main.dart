import 'package:bus_location/core/consts.dart';
import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/entities/user.dart';
import 'package:bus_location/firebase_options.dart';
import 'package:bus_location/models/admin.dart';
import 'package:bus_location/models/driver.dart';
import 'package:bus_location/views/admin/admin_home_page.dart';
import 'package:bus_location/views/client/client_home_page.dart';
import 'package:bus_location/views/driver/driver_home_page.dart';
import 'package:bus_location/views/login_page.dart';
import 'package:bus_location/views/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  bool isAdmin = false;
  bool isAdminVerified = false;
  bool isDriver = false;
  bool isDriverVerfied = false;
  bool isClient = false;

  getUser() async {
    await DatabaseAuthentication().getUser().then((_user) {
      isLoggedIn = true;
      if (_user is Admin) {
        isAdmin = true;
        if (_user.isVerified) {
          isAdminVerified = true;
        }
      } else if (_user is Driver) {
        isDriver = false;
        if (_user.isVerified) {
          isDriverVerfied = true;
        }
      } else {
        isClient = true;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        home: isLoggedIn == true
            ? isAdminVerified == true
                ? AdminHomePage()
                : isDriverVerfied == true
                    ? DriverHomePage()
                    : isClient == true
                        ? ClientHomePage()
                        : LoginPage()
            : LoginPage());
  }
}
