import 'package:admin_panel_tour_app/functions/functions.dart';
import 'package:admin_panel_tour_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    allowAdminLogin() async {
      if (email.isEmpty && password.isEmpty) {
        showReusableSnackBar(context, 'Please check email & password');
      } else {
        User? currentAdmin;
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          currentAdmin = value.user;
        }).catchError((error) {
          showReusableSnackBar(context, 'Error' + error.toString());
        });

        await FirebaseFirestore.instance
            .collection('admins')
            .doc(currentAdmin!.uid)
            .get()
            .then((snapshot) {
          if (snapshot.exists) {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => HomeScreen()));
          } else {
            showReusableSnackBar(context, 'Keshirińiz.. siz ákimshi emessiz');
          }
        });
      }
    }

    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: size * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/admin.png'),
                  TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          icon: Icon(
                            Icons.email,
                            color: Colors.deepPurpleAccent,
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          icon: Icon(
                            Icons.password,
                            color: Colors.deepPurpleAccent,
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showReusableSnackBar(context,
                            'Tirkelgi derekterin teksergende, kúte turyńyz...');

                        allowAdminLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                        primary: Colors.deepPurpleAccent,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontSize: 16,
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
