// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/core/consts.dart';
import 'package:bus_location/database/database_rental.dart';
import 'package:bus_location/entities/location.dart';
import 'package:flutter/material.dart';

import 'package:bus_location/entities/bus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ClientAddReservationPage extends StatefulWidget {
  Bus bus;
  ClientAddReservationPage({
    Key? key,
    required this.bus,
  }) : super(key: key);

  @override
  State<ClientAddReservationPage> createState() =>
      _ClientAddReservationPageState();
}

class _ClientAddReservationPageState extends State<ClientAddReservationPage> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();

  String? busType;
  Location? start;
  Location? destination;
  DateTime? selectedDate;

  double distance = 0.0;
  calculateDistace(Location start, Location destination) async {
    final _distance = await Geolocator.distanceBetween(start.latitude,
        start.longitude, destination.latitude, destination.longitude);

    setState(() {
      distance = (_distance / 1000);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Rent this Bus"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Fill the Reservation Informations Fields",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return "please fill the field !";
                      }
                    },
                    controller: dateController,
                    onTap: () async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030));
                      if (date != null) {
                        setState(() {
                          dateController.text = DateFormat.yMMMd().format(date);
                          selectedDate = date;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Select Date",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<Location>(
                      decoration: InputDecoration(
                          labelText: "Start",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      value: start,
                      items: tunisianStates
                          .map(
                            (state) => DropdownMenuItem<Location>(
                              child: Text(state.name),
                              value: state,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          start = value;
                          calculateDistace(start!, destination!);
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<Location>(
                      decoration: InputDecoration(
                          labelText: "Destination",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      value: destination,
                      items: tunisianStates
                          .map(
                            (state) => DropdownMenuItem<Location>(
                              child: Text(state.name),
                              value: state,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          destination = value;
                          calculateDistace(start!, destination!);
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Price:${(distance * widget.bus.fee).toInt()} DT",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: primaryColor,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (await DatabaseRental()
                            .checkAvailability(selectedDate!)) {
                          await DatabaseRental().createReservation(
                              context,
                              widget.bus.id,
                              dateController.text,
                              widget.bus.fee,
                              start!,
                              destination!,
                              (distance * widget.bus.fee).toInt());
                        } else {
                          showErrorMessage(
                              context, "bus not avaiable at the selected date");
                        }
                      }
                    },
                    child: Container(
                      width: 170,
                      height: 45,
                      child: const Center(
                        child: Text(
                          "Submit Request",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
