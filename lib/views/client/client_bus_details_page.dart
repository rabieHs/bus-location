import 'package:bus_location/core/consts.dart';
import 'package:bus_location/entities/bus.dart';
import 'package:bus_location/views/client/client_add_reservation_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientBusDetailsPage extends StatefulWidget {
  Bus bus;
  ClientBusDetailsPage({super.key, required this.bus});

  @override
  State<ClientBusDetailsPage> createState() => _ClientFeedPageState();
}

class _ClientFeedPageState extends State<ClientBusDetailsPage> {
  String image = "";
  @override
  void initState() {
    if (!widget.bus.images!.isEmpty) {
      image = widget.bus.images!.first;
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.bus.id),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(15),
                      image: widget.bus.images!.isEmpty
                          ? DecorationImage(
                              image: AssetImage("assets/images/bus.png"))
                          : DecorationImage(
                              image: NetworkImage(
                                image,
                              ),
                              fit: BoxFit.cover)),
                ),
              ),
              Container(
                height: 70,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.bus.images!.isEmpty
                        ? 4
                        : widget.bus.images!.length,
                    // shrinkWrap: true,
                    itemBuilder: (contetx, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              image = widget.bus.images![index];
                            });
                          },
                          child: Container(
                            width: 70,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8),
                                image: widget.bus.images!.isEmpty
                                    ? DecorationImage(
                                        image:
                                            AssetImage("assets/images/bus.png"))
                                    : DecorationImage(
                                        image: NetworkImage(
                                          widget.bus.images![index],
                                        ),
                                        fit: BoxFit.cover)),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                padding: EdgeInsets.all(8),
                height: 330,
                child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.2,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 60,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.bus.energy,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.sell,
                              size: 60,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "${widget.bus.fee} Dt / Km",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.directions_bus_sharp,
                              size: 60,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.bus.type,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              widget.bus.status == "rented"
                                  ? Icons.clear_rounded
                                  : Icons.check_circle_outline,
                              size: 60,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.bus.status,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: widget.bus.status == "rented"
                                      ? Colors.red
                                      : Colors.green),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
              Center(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: primaryColor,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ClientAddReservationPage(
                              bus: widget.bus,
                            )));
                  },
                  child: Container(
                    width: 170,
                    height: 45,
                    child: const Center(
                      child: Text(
                        "Rent this Bus",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
