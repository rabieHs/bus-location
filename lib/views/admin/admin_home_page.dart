import 'package:bus_location/core/consts.dart';
import 'package:bus_location/views/admin/admin_bus_page.dart';
import 'package:bus_location/views/admin/drivers_page.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Widget> adminPages = const [AdminBusPage(), DriversPage()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bus_alert), label: "Bus"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Drivers"),
        ],
      ),
      body: adminPages[currentIndex],
    );
  }
}
