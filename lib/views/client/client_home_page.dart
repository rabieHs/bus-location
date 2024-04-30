import 'package:bus_location/core/consts.dart';
import 'package:bus_location/views/client/client_bus_page.dart';
import 'package:bus_location/views/client/client_profile_page.dart';
import 'package:bus_location/views/client/rent_history_page.dart';
import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  List<Widget> adminPages = [
    ClientBusPage(),
    ClientHistoryPage(),
    ClientProfilePage(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: primaryColor,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: adminPages[currentIndex],
    );
  }
}
