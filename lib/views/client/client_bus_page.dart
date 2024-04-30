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
      body: SingleChildScrollView(
        child: Column(
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
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: busList.length,
                            itemBuilder: (context, index) {
                              Bus bus = busList[index];
                              /* return ListTile(
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
                              );*/

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientBusDetailsPage(
                                                  bus: bus,
                                                )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                15),
                                        image: bus.images!.isEmpty
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/bus.png"))
                                            : DecorationImage(
                                                image: NetworkImage(
                                                  bus.images!.first,
                                                ),
                                                fit: BoxFit.cover)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional.only(
                                                      bottomEnd:
                                                          Radius.circular(15),
                                                      bottomStart:
                                                          Radius.circular(15)),
                                              color: Colors.black
                                                  .withOpacity(0.3)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                bus.id,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.power_input,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bus.energy,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.price_change,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${bus.fee} DT/KM",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.directions_bus,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bus.type,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bus_alert,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bus.status ==
                                                                "waiting for rent"
                                                            ? "available"
                                                            : bus.status,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
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
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: busList.length,
                            itemBuilder: (context, index) {
                              Bus bus = busList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientBusDetailsPage(
                                                  bus: bus,
                                                )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                15),
                                        image: bus.images!.isEmpty
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/bus.png"))
                                            : DecorationImage(
                                                image: NetworkImage(
                                                  bus.images!.first,
                                                ),
                                                fit: BoxFit.cover)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional.only(
                                                      bottomEnd:
                                                          Radius.circular(15),
                                                      bottomStart:
                                                          Radius.circular(15)),
                                              color: Colors.black
                                                  .withOpacity(0.3)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                bus.id,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.power_input,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bus.energy,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.price_change,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${bus.fee} DT/KM",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.directions_bus,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bus.type,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bus_alert,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bus.status ==
                                                                "waiting for rent"
                                                            ? "available"
                                                            : bus.status,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
          ],
        ),
      ),
    );
  }
}
