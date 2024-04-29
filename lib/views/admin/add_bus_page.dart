import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/database/database_bus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/consts.dart';
import '../../models/driver.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final descriptionController = TextEditingController();
  final energyController = TextEditingController();
  final feeController = TextEditingController();
  String? busType;
  String? driver;
  List<Driver> drivers = [];

  getDrivers() async {
    drivers = await DatabaseAuthentication().getDriverList();
    setState(() {});
  }

  @override
  void initState() {
    getDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Bus",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Fill the Bus Informations Fields",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                    controller: idController,
                    decoration: InputDecoration(
                        labelText: "Bus Id",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (valeur) {
                              if (valeur == null || valeur.isEmpty) {
                                return "please fill the field !";
                              }
                            },
                            controller: feeController,
                            decoration: InputDecoration(
                                labelText: "Fee",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (valeur) {
                              if (valeur == null || valeur.isEmpty) {
                                return "please fill the field !";
                              }
                            },
                            controller: energyController,
                            decoration: InputDecoration(
                                labelText: "Energy",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //
                  DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      value: busType,
                      items: const [
                        DropdownMenuItem(
                          child: Text("Mini "),
                          value: "mini Bus",
                        ),
                        DropdownMenuItem(
                          value: "meduim",
                          child: Text("Meduim"),
                        ),
                        DropdownMenuItem(
                          child: Text("Large"),
                          value: "large",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          busType = value;
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),

                  DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Driver",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      value: driver,
                      items: drivers
                          .map(
                            (driver) => DropdownMenuItem(
                              child: Text(driver.name),
                              value: driver.id,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          driver = value;
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    validator: (valeur) {
                      if (valeur == null || valeur.isEmpty) {
                        return "please fill the field !";
                      }
                    },
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: "Energy",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 60,
                              weight: 0.2,
                            ),
                            Text('Add images')
                          ],
                        ),
                      ),
                    ),
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
                        showLoadingDialog(context);
                        await DatabaseBus()
                            .addBus(
                                context,
                                double.parse(feeController.text),
                                busType!,
                                energyController.text,
                                idController.text,
                                descriptionController.text,
                                driver)
                            .whenComplete(() => Navigator.pop(context));
                      }
                    },
                    child: Container(
                      width: 170,
                      height: 45,
                      child: const Center(
                        child: Text(
                          "Register Bus",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
