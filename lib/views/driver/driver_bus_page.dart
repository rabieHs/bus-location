import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../database/athentication.dart';
import '../../database/database_rental.dart';
import '../../entities/rental.dart';
import '../../models/client.dart';

class DriverBusPage extends StatefulWidget {
  const DriverBusPage({super.key});

  @override
  State<DriverBusPage> createState() => _DriverBusPageState();
}

class _DriverBusPageState extends State<DriverBusPage> {
  Future<Client> setUserFromID(
    String clientID,
  ) async {
    return await DatabaseAuthentication().getUserById(clientID) as Client;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My trips",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: DatabaseRental().getRentalForDriver(),
              builder: (context, result) {
                if (result.hasError) {
                  return Center(
                    child: Text("no Rental founs !"),
                  );
                }
                if (result.data == null || result.data!.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Rental> rentralList = result.data!;

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
                                          title: Center(
                                              child: Text(rental.bus_id)),
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
                                                        color: Colors
                                                            .grey.shade600),
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
                                                        color: Colors
                                                            .grey.shade600),
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
                                                        color: Colors
                                                            .grey.shade600),
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
                                                        color: Colors
                                                            .grey.shade600),
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
                                                        color: Colors
                                                            .grey.shade600),
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
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Exit",
                                                style: TextStyle(
                                                    color: rental.status ==
                                                            "rejected"
                                                        ? Colors.grey
                                                        : Colors.red),
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
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              )),
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}
