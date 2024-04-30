import 'package:bus_location/core/consts.dart';
import 'package:bus_location/entities/bus.dart';
import 'package:bus_location/views/client/client_add_reservation_page.dart';
import 'package:flutter/material.dart';

class ClientBusDetailsPage extends StatefulWidget {
  Bus bus;
  ClientBusDetailsPage({super.key, required this.bus});

  @override
  State<ClientBusDetailsPage> createState() => _ClientFeedPageState();
}

class _ClientFeedPageState extends State<ClientBusDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.bus.id),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
    );
  }
}
