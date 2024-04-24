import 'package:flutter/material.dart';

class AdminBusPage extends StatefulWidget {
  const AdminBusPage({super.key});

  @override
  State<AdminBusPage> createState() => _AdminBusPageState();
}

class _AdminBusPageState extends State<AdminBusPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("bus page"),
      ),
    );
  }
}
