import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/entities/rental.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DatabaseRental {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> createReservation(
      BuildContext context, String clientId, busId, date, double fee) async {
    try {
      showLoadingDialog(context);
      final rentId = Uuid().v4();
      final Rental rental = Rental(
          id: rentId,
          date: date,
          fee: fee,
          status: "waiting",
          client_id: clientId,
          bus_id: busId);

      await _firestore
          .collection("rental")
          .doc(rentId)
          .set(rental.toMap())
          .whenComplete(() {
        Navigator.pop(context);
        showSuccessMessage(context, "request sent successfully");
      });
    } catch (e) {
      showErrorMessage(context, "error sending request!");
      Navigator.pop(context);
    }
  }

  Future<void> updateReservation(BuildContext context, Rental rental) async {
    try {
      showLoadingDialog(context);

      await _firestore
          .collection("rental")
          .doc(rental.id)
          .update(rental.toMap())
          .whenComplete(() {
        Navigator.pop(context);
        showSuccessMessage(context, "request updated successfully");
      });
    } catch (e) {
      showErrorMessage(context, "error updating request!");
      Navigator.pop(context);
    }
  }

  Future<void> acceptRejectReservation(
      BuildContext context, String id, String status) async {
    try {
      showLoadingDialog(context);

      await _firestore
          .collection("rental")
          .doc(id)
          .update({"status": status}).whenComplete(() {
        Navigator.pop(context);
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future<void> deleteReservation(
    BuildContext context,
    String id,
  ) async {
    try {
      showLoadingDialog(context);

      await _firestore.collection("rental").doc(id).delete().whenComplete(() {
        Navigator.pop(context);
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getRental() async {
    return _firestore.collection("rental").snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserRental(
      String userId) async {
    return _firestore
        .collection("rental")
        .where("user_id", isEqualTo: userId)
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getRentalWithFilter(
      String filter) async {
    return _firestore
        .collection("rental")
        .where("status", isEqualTo: filter)
        .snapshots();
  }
}