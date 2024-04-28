import 'package:bus_location/core/communMethods.dart';
import 'package:bus_location/core/consts.dart';
import 'package:bus_location/database/athentication.dart';
import 'package:bus_location/models/admin.dart';
import 'package:bus_location/models/driver.dart';
import 'package:bus_location/views/admin/admin_home_page.dart';
import 'package:bus_location/views/client/client_home_page.dart';
import 'package:bus_location/views/driver/driver_home_page.dart';
import 'package:bus_location/views/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
                  "assets/images/bus2.png",
                  width: 250,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Login Now !",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return "please fill the field !";
                          } else if (!valeur.contains("@") ||
                              !valeur.contains(".")) {
                            return "email was badly formatted!";
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (valeur) {
                          if (valeur == null || valeur.isEmpty) {
                            return "please fill the field!";
                          } else if (valeur.length < 6) {
                            return "password too short!";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
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
                            try {
                              final user = await DatabaseAuthentication()
                                  .loginUser(emailController.text,
                                      passwordController.text);
                              if (user is Admin) {
                                if (user.isVerified == true) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminHomePage()));
                                } else {
                                  showWarningMessage(
                                      context, "Waiting for Verification...");
                                }
                              } else if (user is Driver) {
                                if (user.isVerified) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DriverHomePage()));
                                } else {
                                  showWarningMessage(context,
                                      "Driver Waiting for Verification...");
                                }
                              } else {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ClientHomePage()));
                              }
                            } catch (e) {
                              showErrorMessage(context, "Error Login");
                            }
                          }
                        },
                        child: Container(
                          width: 170,
                          height: 45,
                          child: const Center(
                            child: Text(
                              "Login",
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
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage())),
                            child: Text(
                              " Register",
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
