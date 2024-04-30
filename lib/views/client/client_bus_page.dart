import 'package:bus_location/views/client/client_bus_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../database/database_bus.dart';
import '../../entities/bus.dart';

class ClientBusPage extends StatefulWidget {
  const ClientBusPage({super.key});

  @override
  State<ClientBusPage> createState() => _ClientBusPageState();
}

class _ClientBusPageState extends State<ClientBusPage> {
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bus List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
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
                    Text("available for rent"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.green),
                  ],
                ),
                Row(
                  children: [
                    Text("rented"),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(radius: 5, backgroundColor: Colors.red),
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
                        child: CircularProgressIndicator(),
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ClientBusDetailsPage(
                                          bus: bus,
                                        )));
                              },
                              leading: bus.images!.isEmpty
                                  ? Icon(
                                      Icons.bus_alert,
                                      size: 40,
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
                                          ? Colors.green
                                          : Colors.red),
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
                        child: CircularProgressIndicator(),
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
                              onTap: () {},
                              leading: bus.images!.isEmpty
                                  ? Icon(
                                      Icons.bus_alert,
                                      size: 40,
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
