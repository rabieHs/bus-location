import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/models/admin.dart';
import 'package:bus_location/models/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAdminStream;

  streamDrivers() async {
    getAdminStream = await DatabaseAuthentication().getUsers("driver");
    setState(() {});
  }

  @override
  void initState() {
    streamDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Drivers",
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
                if (result.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (result.data!.docs.isEmpty) {
                  return Center(
                    child: Text("there is no drivers"),
                  );
                } else {
                  List<Driver> drivers = result.data!.docs.map((doc) {
                    return Driver.fromMap(doc.data());
                  }).toList();

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: drivers.length,
                      itemBuilder: (context, index) {
                        Driver driver = drivers[index];
                        return ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Center(child: Text(driver.name)),
                                      content: Text(
                                          "You can accept or reject any driver "),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        MaterialButton(
                                          enableFeedback: false,
                                          onPressed: !driver.isVerified
                                              ? null
                                              : () {
                                                  DatabaseAuthentication()
                                                      .rejectAdminDriver(
                                                          context, driver);
                                                },
                                          child: Text(
                                            "reject",
                                            style: TextStyle(
                                                color: !driver.isVerified
                                                    ? Colors.grey
                                                    : Colors.red),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: driver.isVerified
                                              ? null
                                              : () {
                                                  DatabaseAuthentication()
                                                      .acceptAdminDriver(
                                                          context, driver);
                                                },
                                          child: Text(
                                            "accept",
                                            style: TextStyle(
                                                color: driver.isVerified
                                                    ? Colors.grey
                                                    : Colors.green),
                                          ),
                                        ),
                                      ],
                                    ));
                          },
                          leading: Image.asset(
                            "assets/images/driver.png",
                            width: 40,
                            height: 40,
                          ),
                          title: Text(driver.name),
                          subtitle: Text(driver.email),
                          trailing: CircleAvatar(
                            radius: 6,
                            backgroundColor:
                                driver.isVerified ? Colors.green : Colors.red,
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
