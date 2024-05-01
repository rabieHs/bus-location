import 'dart:async';

import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/entities/user.dart';
import 'package:bus_location/models/admin.dart';
import 'package:bus_location/models/client.dart';
import 'package:bus_location/models/driver.dart';
import 'package:bus_location/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/material.dart';

class DatabaseAuthentication {
  final _auth = auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User> loginUser(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (result.user != null) {
      final user =
          await _firestore.collection("users").doc(result.user!.uid).get();
      final userData = user.data()!;
      if (userData["type"] == "admin") {
        return Admin.fromMap(userData);
      } else if (userData["type"] == "driver") {
        return Driver.fromMap(userData);
      } else {
        return Client.fromMap(userData);
      }
    } else {
      throw Exception();
    }
  }

  Future<bool> registerUser(String name, String lastname, String email,
      String type, String? phone, String password) async {
    final resultat = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (resultat.user != null) {
      if (type == "admin") {
        final admin = Admin(
            phone: phone!,
            name: name,
            lastname: lastname,
            email: email,
            id: resultat.user!.uid);
        await _firestore.collection("users").doc(admin.id).set(admin.toMap());
        return true;
      } else if (type == "driver") {
        final driver = Driver(
            name: name,
            lastname: lastname,
            email: email,
            id: resultat.user!.uid);
        await _firestore.collection("users").doc(driver.id).set(driver.toMap());
        return true;
      } else {
        final client = Client(
            name: name,
            lastname: lastname,
            email: email,
            id: resultat.user!.uid);
        await _firestore.collection("users").doc(client.id).set(client.toMap());
        return true;
      }
    } else {
      return false;
    }
  }

  Future<User> getUserById(String uid) async {
    final result = await _firestore.collection("users").doc(uid).get();
    final userData = result.data()!;

    if (userData["type"] == "admin") {
      return Admin.fromMap(userData);
    } else if (userData["type"] == "driver") {
      return Driver.fromMap(userData);
    } else {
      return Client.fromMap(userData);
    }
  }

  Future<User> getUser() async {
    final result =
        await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
    final userData = result.data()!;

    if (userData["type"] == "admin") {
      return Admin.fromMap(userData);
    } else if (userData["type"] == "driver") {
      return Driver.fromMap(userData);
    } else {
      return Client.fromMap(userData);
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUsers(
      String type) async {
    return _firestore
        .collection("users")
        .where("type", isEqualTo: type)
        .snapshots();
  }

  Future<List<Driver>> getDriverList() async {
    final result = await _firestore
        .collection("users")
        .where("type", isEqualTo: "driver")
        .get();
    return result.docs.map((doc) => Driver.fromMap(doc.data())).toList();
  }

  void acceptAdminDriver(BuildContext context, User user) async {
    await _firestore
        .collection("users")
        .doc(user.id)
        .update({"isVerified": true}).then((value) {
      Navigator.pop(context);
      showSuccessMessage(context, "${user.name} was accepted successfully ");
    });
  }

  void rejectAdminDriver(BuildContext context, User user) async {
    await _firestore
        .collection("users")
        .doc(user.id)
        .update({"isVerified": false}).then((value) {
      Navigator.pop(context);
      showSuccessMessage(context, "${user.name} was rejected successfully ");
    });
  }

  void updateClient(Client client, BuildContext context) async {
    await _firestore
        .collection("users")
        .doc(client.id)
        .update(client.toMap())
        .then((value) {
      Navigator.pop(context);
      showSuccessMessage(context, " Profile Updated successfully ");
    });
  }

  void updateAdmin(Admin admin, BuildContext context) async {
    await _firestore
        .collection("users")
        .doc(admin.id)
        .update(admin.toMap())
        .then((value) {
      Navigator.pop(context);
      showSuccessMessage(context, " Profile Updated successfully ");
    });
  }

  void updateDriver(Driver driver, BuildContext context) async {
    await _firestore
        .collection("users")
        .doc(driver.id)
        .update(driver.toMap())
        .then((value) {
      Navigator.pop(context);
      showSuccessMessage(context, " Profile Updated successfully ");
    });
  }

  updateUserEmail(BuildContext context, User user, String email,
      auth.AuthCredential credentaial) async {
    final cred =
        await _auth.currentUser!.reauthenticateWithCredential(credentaial);

    await cred.user!.updateEmail(email).whenComplete(() async {
      user.email = _auth.currentUser!.email!;
      await _firestore
          .collection("users")
          .doc(user.id)
          .update({"email": email}).then((value) {
        Navigator.pop(context);
        showSuccessMessage(context, " Email Updated successfully ");
      });
    });
  }

  updateUserPassword(BuildContext context, User user, String password,
      auth.AuthCredential credentaial) async {
    final cred =
        await _auth.currentUser!.reauthenticateWithCredential(credentaial);

    await cred.user!.updatePassword(password).whenComplete(() async {
      Navigator.pop(context);
      showSuccessMessage(context, " Email Updated successfully ");
    });
  }

  signOut(BuildContext context) async {
    await _auth.signOut().whenComplete(() => Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage())));
  }
}
