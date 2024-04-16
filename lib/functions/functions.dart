import 'package:admin_panel_tour_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

showReusableSnackBar(BuildContext context, String title) {
  SnackBar snackBar = SnackBar(
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 2),
      content: Text(
        title.toString(),
        style: const TextStyle(color: Colors.white),
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
