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

class AdminClientsPage extends StatefulWidget {
  const AdminClientsPage({super.key});

  @override
  State<AdminClientsPage> createState() =>
      _AdminsBusReservationsRequestPageState();
}

class _AdminsBusReservationsRequestPageState extends State<AdminClientsPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getClientsStream;
  List<String> busFilterTypes = [
    "all",
    "waiting",
    "accepted",
    "rejected",
  ];
  int selectedIndex = 0;
  final searchController = TextEditingController();

  streamUsers() async {
    getClientsStream = await DatabaseAuthentication().getUsers("client");
    setState(() {});
  }

  @override
  void initState() {
    streamUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Our Clients",
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
            height: 60,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: TextFormField(
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    getClientsStream = await DatabaseAuthentication()
                        .getUsersWithSearch("client", value);
                  } else {
                    selectedIndex = 0;
                    getClientsStream =
                        await DatabaseAuthentication().getUsers("client");
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
              stream: getClientsStream,
              builder: (context, result) {
                if (result.hasError) {
                  print(result.error);
                  return Center(
                    child: Text("error occured !"),
                  );
                }
                if (result.data == null || result.data!.docs.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Client> clientList = result.data!.docs.map((doc) {
                    return Client.fromMap(doc.data());
                  }).toList();

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: clientList.length,
                      itemBuilder: (context, index) {
                        Client client = clientList[index];
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey.shade300),
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300))),
                          child: ListTile(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title:
                                              Center(child: Text(client.id!)),
                                          content: Container(
                                            child: FutureBuilder(
                                                future: DatabaseRental()
                                                    .getRentalForClient(client),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text("error"),
                                                    );
                                                  }
                                                  if (snapshot.data == null ||
                                                      result
                                                          .data!.docs.isEmpty ||
                                                      !result.hasData ||
                                                      !result.data!.docs.first
                                                          .exists) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    final rentals =
                                                        snapshot.data!;

                                                    return Container(
                                                      height: 250,
                                                      width: 600,
                                                      child: ListView.builder(
                                                          itemCount:
                                                              rentals.length,
                                                          itemBuilder:
                                                              (conext, index) {
                                                            final rental =
                                                                rentals[index];
                                                            return ListTile(
                                                              title: Text(rental
                                                                  .bus_id),
                                                              subtitle: Text(
                                                                  rental.date),
                                                              trailing: Text(
                                                                  "${rental.totalPrice} DT"),
                                                            );
                                                          }),
                                                    );
                                                  }
                                                }),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            MaterialButton(
                                              enableFeedback: false,
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "close",
                                                style: TextStyle(
                                                    color: Colors.red),
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
                                client.name,
                              ),
                              subtitle: Text(client.email),
                              trailing: Icon(Icons.arrow_forward_ios)),
                        );
                      });
                }
              }),
        ],
      ),
    );
  }
}
