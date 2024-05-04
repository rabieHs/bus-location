import 'package:bus_location/database/database_rental.dart';
import 'package:bus_location/views/client/client_update_rent_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../database/athentication.dart';
import '../../entities/rental.dart';
import '../../models/client.dart';

class ClientHistoryPage extends StatefulWidget {
  const ClientHistoryPage({super.key});

  @override
  State<ClientHistoryPage> createState() => _ClientHistoryPageState();
}

class _ClientHistoryPageState extends State<ClientHistoryPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getRequestsStream;

  Future<Client> setUserFromID(
    String clientID,
  ) async {
    return await DatabaseAuthentication().getUserById(clientID) as Client;
  }

  streamRentals() async {
    getRequestsStream = await DatabaseRental()
        .getUserRental(FirebaseAuth.instance.currentUser!.uid);
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
          StreamBuilder(
              stream: getRequestsStream,
              builder: (context, result) {
                if (result.hasError) {
                  return Center(
                    child: Text("error occured !"),
                  );
                }
                if (result.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (result.data!.docs.isEmpty) {
                  return Center(
                    child: Text("you have no Requests"),
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
                                            onPressed: () async {
                                              await DatabaseRental()
                                                  .deleteReservation(
                                                      context, rental.id)
                                                  .whenComplete(() =>
                                                      Navigator.pop(context));
                                            },
                                            child: Text(
                                              "delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          MaterialButton(
                                            enableFeedback: false,
                                            onPressed: () async {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClientUpdateReservationPage(
                                                              rental: rental)));
                                            },
                                            child: Text(
                                              "update",
                                              style: TextStyle(
                                                  color: Colors.orange),
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
