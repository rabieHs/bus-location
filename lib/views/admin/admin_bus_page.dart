import 'package:bus_location/database/database_bus.dart';
import 'package:bus_location/entities/bus.dart';
import 'package:bus_location/views/admin/add_bus_page.dart';
import 'package:bus_location/views/admin/update_bus_page.dart';
import 'package:bus_location/views/client/client_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBusPage extends StatefulWidget {
  const AdminBusPage({super.key});

  @override
  State<AdminBusPage> createState() => _AdminBusPageState();
}

class _AdminBusPageState extends State<AdminBusPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? getBusStream;
  List<String> busFilterTypes = ["all", "mini", "meduim", "large"];
  int selectedIndex = 0;

  streamBus() async {
    getBusStream = await DatabaseBus().getBus();
    setState(() {});
  }

  @override
  void initState() {
    streamBus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBusPage()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bus List",
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 280,
            height: 50,
            //width: MediaQuery.of(context).size.width,
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
                        getBusStream = await DatabaseBus().getBus();
                      } else {
                        getBusStream = await DatabaseBus()
                            .getBusWithFilter(busFilterTypes[index]);
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
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text("waiting for rent"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.yellow),
                  ],
                ),
                Row(
                  children: [
                    Text("rented"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.green),
                  ],
                ),
              ],
            ),
          ),
          selectedIndex != 0
              ? StreamBuilder(
                  stream: getBusStream,
                  builder: (context, result) {
                    if (result.hasError) {
                      return Center(
                        child: Text("error occured !"),
                      );
                    }
                    if (result.data == null) {
                      return Center(
                        child: Text(""),
                      );
                    }
                    if (!result.hasData) {
                      return Center(
                        child: Text(""),
                      );
                    }
                    if (result.data!.docs.isEmpty) {
                      return Center(
                        child: Text(""),
                      );
                    } else {
                      List<Bus> busList = result.data!.docs.map((doc) {
                        return Bus.fromMap(doc.data());
                      }).toList();

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: busList.length,
                          itemBuilder: (context, index) {
                            Bus bus = busList[index];
                            return ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Center(child: Text(bus.id)),
                                          content: Text(
                                              "You can accept or reject any admin "),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            MaterialButton(
                                              onPressed: () async {
                                                await DatabaseBus()
                                                    .deleteBus(context, bus.id);
                                              },
                                              child: Text(
                                                "delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateBusPage(
                                                                bus: bus)));
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
                              leading: bus.images!.isEmpty
                                  ? Image.asset(
                                      "assets/images/bus_icon.png",
                                      width: 40,
                                      height: 40,
                                    )
                                  : Image.network(
                                      bus.images!.first,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                              title: Text(bus.id),
                              subtitle: Text(bus.status),
                              trailing: CircleAvatar(
                                  radius: 6,
                                  backgroundColor:
                                      bus.status == "waiting for rent"
                                          ? Colors.yellow
                                          : Colors.green),
                            );
                          });
                    }
                  })
              : StreamBuilder(
                  stream: getBusStream,
                  builder: (context, result) {
                    if (result.hasError) {
                      return Center(
                        child: Text("error occured !"),
                      );
                    }
                    if (result.data == null) {
                      return Center(
                        child: Text(""),
                      );
                    }
                    if (!result.hasData) {
                      return Center(
                        child: Text(""),
                      );
                    }
                    if (result.data!.docs.isEmpty) {
                      return Center(
                        child: Text(""),
                      );
                    } else {
                      List<Bus> busList = result.data!.docs.map((doc) {
                        return Bus.fromMap(doc.data());
                      }).toList();

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: busList.length,
                          itemBuilder: (context, index) {
                            Bus bus = busList[index];
                            return ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Center(child: Text(bus.id)),
                                          content: Text(
                                              "You can accept or reject any admin "),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            MaterialButton(
                                              onPressed: () async {
                                                await DatabaseBus()
                                                    .deleteBus(context, bus.id);
                                              },
                                              child: Text(
                                                "delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateBusPage(
                                                                bus: bus)));
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
                              leading: bus.images!.isEmpty
                                  ? Image.asset(
                                      "assets/images/bus_icon.png",
                                      width: 40,
                                      height: 40,
                                    )
                                  : Image.network(
                                      bus.images!.first,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                              title: Text(bus.id),
                              subtitle: Text(bus.status),
                              trailing: CircleAvatar(
                                  radius: 6,
                                  backgroundColor:
                                      bus.status == "waiting for rent"
                                          ? Colors.yellow
                                          : Colors.green),
                            );
                          });
                    }
                  }),
        ],
      ),
    );
  }
}
