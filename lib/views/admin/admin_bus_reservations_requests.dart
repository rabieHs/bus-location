import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/database/database_rental.dart';
import 'package:bus_location/entities/rental.dart';
import 'package:bus_location/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../entities/user.dart';
import '../../models/driver.dart';
import '../client/client_profile_page.dart';

class AdminsBusReservationsRequestPage extends StatefulWidget {
  const AdminsBusReservationsRequestPage({super.key});

  @override
  State<AdminsBusReservationsRequestPage> createState() =>
      _AdminsBusReservationsRequestPageState();
}

class _AdminsBusReservationsRequestPageState
    extends State<AdminsBusReservationsRequestPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRequestsStream;
  List<String> busFilterTypes = [
    "all",
    "waiting",
    "accepted",
    "rejected",
  ];
  int selectedIndex = 0;
  final searchController = TextEditingController();

  Future<Client> setUserFromID(
    String clientID,
  ) async {
    return await DatabaseAuthentication().getUserById(clientID) as Client;
  }

  streamRentals() async {
    getRequestsStream = await DatabaseRental().getRental();
    setState(() {});
  }

  @override
  void initState() {
    streamRentals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Reservation Requests",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ClientProfilePage()));
              },
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text("waiting"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.yellow),
                  ],
                ),
                Row(
                  children: [
                    Text("accepted"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.green),
                  ],
                ),
                Row(
                  children: [
                    Text("rejected"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.red),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 1.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: busFilterTypes.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      selectedIndex = index;
                      if (index == 0) {
                        getRequestsStream = await DatabaseRental().getRental();
                      } else {
                        getRequestsStream = await DatabaseRental()
                            .getRentalWithFilter(busFilterTypes[index]);
                      }
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: index == selectedIndex
                              ? null
                              : Border.all(width: 1.5, color: Colors.orange),
                          color: index == selectedIndex
                              ? Colors.orange
                              : Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      height: 30,
                      child: Center(
                        child: Text(
                          busFilterTypes[index],
                          style: TextStyle(
                            color: index == selectedIndex
                                ? Colors.white
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            height: 60,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: TextFormField(
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    getRequestsStream =
                        await DatabaseRental().getRentalWithSearch(value);
                  } else {
                    selectedIndex = 0;
                    getRequestsStream = await DatabaseRental().getRental();
                  }
                  setState(() {});
                },
                validator: (valeur) {
                  if (valeur == null || valeur.isEmpty) {
                    return "please fill the field !";
                  }
                },
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(bottom: 5, left: 20),
                    labelText: "search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
          ),
          StreamBuilder(
              stream: getRequestsStream,
              builder: (context, result) {
                if (result.hasError) {
                  return Center(
                    child: Text("error occured !"),
                  );
                }
                if (result.data == null || result.data!.docs.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Rental> rentralList = result.data!.docs.map((doc) {
                    return Rental.fromMap(doc.data());
                  }).toList();

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: rentralList.length,
                      itemBuilder: (context, index) {
                        Rental rental = rentralList[index];
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey.shade300),
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300))),
                          child: ListTile(
                            onTap: () async {
                              Client client =
                                  await setUserFromID(rental.client_id);
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title:
                                            Center(child: Text(rental.bus_id)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Client Name:   ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  client.name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Client Eamil:   ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  client.email,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Start Location:   ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  rental.start.name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Destination Location:   ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  rental.destination.name,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Total Price:   ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  "${rental.totalPrice} Dt",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          MaterialButton(
                                            enableFeedback: false,
                                            onPressed:
                                                rental.status == "rejected"
                                                    ? null
                                                    : () async {
                                                        await DatabaseRental()
                                                            .acceptRejectReservation(
                                                                context,
                                                                rental.id,
                                                                "rejected",
                                                                rental.bus_id)
                                                            .whenComplete(() =>
                                                                Navigator.pop(
                                                                    context));
                                                      },
                                            child: Text(
                                              "reject",
                                              style: TextStyle(
                                                  color: rental.status ==
                                                          "rejected"
                                                      ? Colors.grey
                                                      : Colors.red),
                                            ),
                                          ),
                                          MaterialButton(
                                            enableFeedback: false,
                                            onPressed:
                                                rental.status == "accepted"
                                                    ? null
                                                    : () async {
                                                        await DatabaseRental()
                                                            .acceptRejectReservation(
                                                                context,
                                                                rental.id,
                                                                "accepted",
                                                                rental.bus_id)
                                                            .whenComplete(() =>
                                                                Navigator.pop(
                                                                    context));
                                                      },
                                            child: Text(
                                              "accept",
                                              style: TextStyle(
                                                  color: rental.status ==
                                                          "accepted"
                                                      ? Colors.grey
                                                      : Colors.green),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            leading: Image.asset(
                              "assets/images/key.png",
                              width: 40,
                              height: 40,
                            ),
                            title: Text(
                              rental.id,
                            ),
                            subtitle: Text(rental.date),
                            trailing: CircleAvatar(
                              radius: 6,
                              backgroundColor: rental.status == "accepted"
                                  ? Colors.green
                                  : rental.status == "waiting"
                                      ? Colors.yellow
                                      : Colors.red,
                            ),
                          ),
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}
