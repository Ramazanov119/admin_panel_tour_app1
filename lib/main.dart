import 'package:admin_panel_tour_app/screens/add_tour.dart';
import 'package:admin_panel_tour_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/login_screen.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBhU1StNaEB8Nk_lt4I0cxcsnGGTvod82k",
        appId: "1:192436663781:web:2ea382f9c8b3c6020e2b0c",
        messagingSenderId: "192436663781",
        projectId: "ongid-76aca",
        storageBucket: 'ongid-76aca.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
