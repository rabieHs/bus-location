import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/models/admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../client/client_profile_page.dart';

class AdminsPage extends StatefulWidget {
  AdminsPage({super.key});

  @override
  State<AdminsPage> createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAdminStream;

  streamAdmins() async {
    getAdminStream = await DatabaseAuthentication().getUsers("admin");
    setState(() {});
  }

  @override
  void initState() {
    streamAdmins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        centerTitle: true,
        title: Text(
          "Admins",
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
              stream: getAdminStream,
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
                  List<Admin> admins = result.data!.docs.map((doc) {
                    return Admin.fromMap(doc.data());
                  }).toList();

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: admins.length,
                      itemBuilder: (context, index) {
                        Admin admin = admins[index];
                        return ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Center(child: Text(admin.name)),
                                      content: Text(
                                          "You can accept or reject any admin "),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        MaterialButton(
                                          enableFeedback: false,
                                          onPressed: !admin.isVerified
                                              ? null
                                              : () {
                                                  DatabaseAuthentication()
                                                      .rejectAdminDriver(
                                                          context, admin);
                                                },
                                          child: Text(
                                            "reject",
                                            style: TextStyle(
                                                color: !admin.isVerified
                                                    ? Colors.grey
                                                    : Colors.red),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: admin.isVerified
                                              ? null
                                              : () {
                                                  DatabaseAuthentication()
                                                      .acceptAdminDriver(
                                                          context, admin);
                                                },
                                          child: Text(
                                            "accept",
                                            style: TextStyle(
                                                color: admin.isVerified
                                                    ? Colors.grey
                                                    : Colors.green),
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                          leading: Icon(Icons.person),
                          title: Text(admin.name),
                          subtitle: Text(admin.email),
                          trailing: CircleAvatar(
                            radius: 6,
                            backgroundColor:
                                admin.isVerified ? Colors.green : Colors.red,
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
