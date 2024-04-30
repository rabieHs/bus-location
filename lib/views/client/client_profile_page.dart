import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/entities/user.dart';
import 'package:bus_location/models/admin.dart';
import 'package:bus_location/models/client.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/consts.dart';
import '../../models/driver.dart';

class ClientProfilePage extends StatefulWidget {
  ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  User? user;

  getUser() async {
    user = await DatabaseAuthentication().getUser();
    nameController.text = user!.name;
    lastNameController.text = user!.lastname;
    emailController.text = user!.email;
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              SafeArea(
                  child: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 70,
                ),
                radius: 70,
              )),
              SizedBox(
                height: 20,
              ),
              Text(
                user != null ? user!.name : "",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Center(child: Text("update Name")),
                              content: TextFormField(
                                validator: (valeur) {
                                  if (valeur == null || valeur.isEmpty) {
                                    return "please fill the field !";
                                  }
                                },
                                controller: nameController,
                                decoration: InputDecoration(
                                    labelText: "User Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("exit"),
                                  textColor: Colors.red,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (user is Client) {
                                      user!.name = nameController.text;
                                      if (user != null) {
                                        DatabaseAuthentication().updateClient(
                                            user as Client, context);
                                      }
                                    } else if (user is Admin) {
                                      user!.name = nameController.text;

                                      if (user != null) {
                                        DatabaseAuthentication().updateAdmin(
                                            user as Admin, context);
                                      }
                                    } else if (user is Driver) {
                                      user!.name = nameController.text;

                                      if (user != null) {
                                        DatabaseAuthentication().updateDriver(
                                            user as Driver, context);
                                      }
                                    } else {}
                                  },
                                  child: Text("save"),
                                  textColor: Colors.green,
                                ),
                              ],
                            ));
                  },
                  leading: Icon(Icons.person),
                  title: Text("Name"),
                  subtitle: Text(user == null ? "" : user!.name),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Center(child: Text("update last Name")),
                              content: TextFormField(
                                validator: (valeur) {
                                  if (valeur == null || valeur.isEmpty) {
                                    return "please fill the field !";
                                  }
                                },
                                controller: lastNameController,
                                decoration: InputDecoration(
                                    labelText: "Last Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("exit"),
                                  textColor: Colors.red,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (user is Client) {
                                      user!.lastname = lastNameController.text;
                                      if (user != null) {
                                        DatabaseAuthentication().updateClient(
                                            user as Client, context);
                                      }
                                    } else if (user is Admin) {
                                      user!.lastname = lastNameController.text;

                                      if (user != null) {
                                        DatabaseAuthentication().updateAdmin(
                                            user as Admin, context);
                                      }
                                    } else if (user is Driver) {
                                      user!.lastname = lastNameController.text;

                                      if (user != null) {
                                        DatabaseAuthentication().updateDriver(
                                            user as Driver, context);
                                      }
                                    } else {}
                                  },
                                  child: Text("save"),
                                  textColor: Colors.green,
                                ),
                              ],
                            ));
                  },
                  leading: Icon(Icons.person),
                  title: Text("Last Name"),
                  subtitle: Text(user == null ? "" : user!.lastname),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Center(child: Text("update Email")),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    validator: (valeur) {
                                      if (valeur == null || valeur.isEmpty) {
                                        return "please fill the field !";
                                      }
                                    },
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        labelText: "Email",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    validator: (valeur) {
                                      if (valeur == null || valeur.isEmpty) {
                                        return "please fill the field !";
                                      }
                                    },
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        labelText: "password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                  ),
                                ],
                              ),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("exit"),
                                  textColor: Colors.red,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (passwordController.text.isEmpty ||
                                        emailController.text.isEmpty) {
                                      showErrorMessage(
                                          context, "please fill all fields");
                                    } else {
                                      auth.AuthCredential credential =
                                          auth.EmailAuthProvider.credential(
                                              email: user!.email,
                                              password:
                                                  passwordController.text);
                                      DatabaseAuthentication().updateUserEmail(
                                          context,
                                          user!,
                                          emailController.text,
                                          credential);
                                    }
                                  },
                                  child: Text("save"),
                                  textColor: Colors.green,
                                ),
                              ],
                            ));
                  },
                  leading: Icon(Icons.email),
                  title: Text("Email"),
                  subtitle: Text(user == null ? "" : user!.email),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)),
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Center(child: Text("update Password")),
                              content: TextFormField(
                                obscureText: true,
                                validator: (valeur) {
                                  if (valeur == null || valeur.isEmpty) {
                                    return "please fill the field !";
                                  }
                                },
                                controller: passwordController,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("exit"),
                                  textColor: Colors.red,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (passwordController.text.isEmpty ||
                                        emailController.text.isEmpty) {
                                      showErrorMessage(
                                          context, "please fill all fields");
                                    } else {
                                      auth.AuthCredential credential =
                                          auth.EmailAuthProvider.credential(
                                              email: user!.email,
                                              password:
                                                  passwordController.text);
                                      DatabaseAuthentication()
                                          .updateUserPassword(
                                              context,
                                              user!,
                                              passwordController.text,
                                              credential);
                                    }
                                  },
                                  child: Text("save"),
                                  textColor: Colors.green,
                                ),
                              ],
                            ));
                  },
                  leading: Icon(Icons.password),
                  title: Text("Password"),
                  subtitle: Text("*********"),
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: primaryColor,
                onPressed: () async {},
                child: Container(
                  width: 170,
                  height: 45,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign out",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
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
