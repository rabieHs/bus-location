// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bus_location/core/consts.dart';
import 'package:bus_location/entities/location.dart';
import 'package:flutter/material.dart';

import 'package:bus_location/entities/rental.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../database/database_rental.dart';

class ClientUpdateReservationPage extends StatefulWidget {
  final Rental rental;
  const ClientUpdateReservationPage({
    Key? key,
    required this.rental,
  }) : super(key: key);

  @override
  State<ClientUpdateReservationPage> createState() =>
      _ClientUpdateReservationPageState();
}

class _ClientUpdateReservationPageState
    extends State<ClientUpdateReservationPage> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();

  Location? start;
  Location? destination;

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
    dateController.text = widget.rental.date;
    start = widget.rental.start;
    destination = widget.rental.destination;
    calculateDistace(start!, destination!);

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Update My Request"),
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
                      value: start!,
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
                          labelText: "destination",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      value: destination ?? null,
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
                    "Price:${(distance * widget.rental.fee).toInt()} DT",
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
                        final Rental rental = Rental(
                            id: widget.rental.id,
                            date: dateController.text,
                            fee: widget.rental.fee,
                            status: "waiting",
                            client_id: widget.rental.client_id,
                            bus_id: widget.rental.bus_id,
                            start: start!,
                            destination: destination!,
                            totalPrice: (distance * widget.rental.fee).toInt());
                        await DatabaseRental()
                            .updateReservation(context, rental);
                      }
                    },
                    child: Container(
                      width: 170,
                      height: 45,
                      child: const Center(
                        child: Text(
                          "Update Request",
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
