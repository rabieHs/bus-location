import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/database/database_bus.dart';
import 'package:bus_location/entities/bus.dart';
import 'package:bus_location/entities/location.dart';
import 'package:bus_location/entities/rental.dart';
import 'package:bus_location/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DatabaseRental {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> createReservation(BuildContext context, busId, date, double fee,
      Location start, Location destination, int totalPrice) async {
    try {
      showLoadingDialog(context);
      final rentId = Uuid().v4();
      final Rental rental = Rental(
          start: start,
          destination: destination,
          id: rentId,
          date: date,
          fee: fee,
          totalPrice: totalPrice,
          status: "waiting",
          client_id: _auth.currentUser != null ? _auth.currentUser!.uid : "",
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
      print(e);

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
      BuildContext context, String id, String status, String busId) async {
    try {
      showLoadingDialog(context);

      await _firestore
          .collection("rental")
          .doc(id)
          .update({"status": status}).whenComplete(() async {
        if (status == "accepted") {
          await _firestore
              .collection("bus")
              .doc(busId)
              .update({"status": "rented"});
        } else {
          await _firestore
              .collection("bus")
              .doc(busId)
              .update({"status": "waiting for rent"});
        }
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

  Future<bool> checkAvailability(DateTime date, Bus bus) async {
    List<Rental> rentals = await getAllRentalsByBus(bus.id);

    bool acceptedRentals = rentals.any((rental) {
      final DateTime rental_date = DateFormat.yMMMd().parse(rental.date);
      if (rental_date == date) {
        return false;
      } else {
        return true;
      }
    });

    return acceptedRentals;
  }

  void checkAndUpdateBusRental() async {
    List<Rental> rentals = await getAllRentals();

    rentals.forEach((rental) async {
      DateTime rentalDate = DateFormat.yMMMd().parse(rental.date);

      if (rentalDate.month > DateTime.now().month ||
          rentalDate.day > DateTime.now().day) {
        await _firestore
            .collection("bus")
            .doc(rental.bus_id)
            .update({"status": "waiting for rent"});
      }
    });
  }

  Future<List<Rental>> getRentalForClient(Client client) async {
    final result = await _firestore
        .collection("rental")
        .where("client_id", isEqualTo: client.id)
        .get();
    return result.docs.map((e) => Rental.fromMap(e.data())).toList();
  }

  Future<List<Rental>> getAllRentals() async {
    final result = await _firestore.collection("rental").get();
    return result.docs.map((e) => Rental.fromMap(e.data())).toList();
  }

  Future<List<Rental>> getAllRentalsByBus(String id) async {
    final result = await _firestore
        .collection("rental")
        .where("bus_id", isEqualTo: id)
        .get();
    return result.docs.map((e) => Rental.fromMap(e.data())).toList();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserRental(
      String userId) async {
    return _firestore
        .collection("rental")
        .where("client_id", isEqualTo: userId)
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getRentalWithFilter(
      String filter) async {
    return _firestore
        .collection("rental")
        .where("status", isEqualTo: filter)
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getRentalWithSearch(
      String searchQuery) async {
    return _firestore
        .collection("rental")
        .where("id", isGreaterThanOrEqualTo: searchQuery)
        .snapshots();
  }

  Future<List<Rental>> getRentalForDriver() async {
    //DateFormat.yMMMd().parse()
    List<Rental> rentals = [];
    List<Bus> myBus;

    final busResult = await _firestore
        .collection("bus")
        .where("driver_id", isEqualTo: _auth.currentUser!.uid)
        .get();

    myBus = busResult.docs.map((e) => Bus.fromMap(e.data())).toList();

    for (int i = 0; i < myBus.length; i++) {
      final rentalResult = await _firestore
          .collection("rental")
          .where("bus_id", isEqualTo: myBus[i].id)
          .get();
      return rentalResult.docs.map((rental) {
        return Rental.fromMap(rental.data());
      }).toList();
    }

    return rentals;
  }
}
