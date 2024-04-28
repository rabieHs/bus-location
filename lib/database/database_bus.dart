import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/entities/bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class DatabaseBus {
  final _auth = auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Future<void> addBus(BuildContext context, double fee, String type,
      String energy, String id, String description, String? driverId) async {
    final Bus bus = Bus(
        description: description,
        id: id,
        fee: fee,
        type: type,
        energy: energy,
        driver_id: driverId);

    try {
      await _firestore
          .collection("bus")
          .doc(id)
          .set(bus.toMap())
          .whenComplete(() {
        Navigator.pop(context);
        showSuccessMessage(context, "Bus added successfully");
      });
    } catch (e) {
      showErrorMessage(context, "an error occured");
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getBus() async {
    return _firestore.collection("bus").snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getBusWithFilter(
      String filter) async {
    return _firestore
        .collection("bus")
        .where("type", isEqualTo: filter)
        .snapshots();
  }

  Future<void> updateBus(BuildContext context, double fee, String type,
      String energy, String id, String description, String? driverId) async {
    final Bus bus = Bus(
        description: description,
        id: id,
        fee: fee,
        type: type,
        energy: energy,
        driver_id: driverId);

    try {
      await _firestore
          .collection("bus")
          .doc(id)
          .update(bus.toMap())
          .whenComplete(() {
        Navigator.pop(context);
        showSuccessMessage(context, "Bus Updated successfully");
      });
    } catch (e) {
      showErrorMessage(context, "an error occured");
    }
  }

  Future<void> deleteBus(BuildContext context, String id) async {
    try {
      await _firestore.collection("bus").doc(id).delete().whenComplete(() {
        Navigator.pop(context);
        showSuccessMessage(context, "Bus deleted successfully");
      });
    } catch (e) {
      showErrorMessage(context, "an error occured");
    }
  }
}
