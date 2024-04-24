import 'package:bus_location/core/consts.dart';
import 'package:bus_location/views/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? userType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/bus.png",
                  width: 250,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Join US Now !",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          labelText: "Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      value: userType,
                      items: const [
                        DropdownMenuItem(
                          child: Text("Client"),
                          value: "client",
                        ),
                        DropdownMenuItem(
                          value: "admin",
                          child: Text("Admin"),
                        ),
                        DropdownMenuItem(
                          child: Text("Driver"),
                          value: "driver",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          userType = value;
                        });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  userType == "admin"
                      ? TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "Phone",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: primaryColor,
                    onPressed: () {},
                    child: Container(
                      width: 170,
                      height: 45,
                      child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => LoginPage())),
                        child: Text(
                          " Login",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
