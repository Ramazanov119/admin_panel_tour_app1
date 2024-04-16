import 'dart:async';

import 'package:admin_panel_tour_app/screens/add_hotel.dart';
import 'package:admin_panel_tour_app/screens/add_tour.dart';
import 'package:admin_panel_tour_app/screens/view_hotels_screen.dart';
import 'package:admin_panel_tour_app/screens/view_recom.dart';
import 'package:admin_panel_tour_app/screens/view_tours_screen.dart';
import 'package:admin_panel_tour_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../responsive.dart';
import '../widgets/app_bar.dart';
import '../widgets/grid_tour.dart';
import 'add_recom.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveTime = "";
  String liveDate = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time) {
    return DateFormat("dd MMMM, yyyy").format(time);
  }

  getCurrentLiveTimeDate() {
    liveTime = formatCurrentLiveTime(DateTime.now());
    liveDate = formatCurrentLiveDate(DateTime.now());

    setState(() {
      liveTime;
      liveDate;
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTimeDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  liveTime + "\n" + liveDate,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => ViewToursScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.pinkAccent,
                          Colors.deepPurpleAccent,
                        ])),
                    child: TextWidget(
                      text: 'View Tours',
                      color: Colors.white,
                      textSize: 15,
                      fontFamily: 'Cormorant',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => ViewHotelsScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.pinkAccent,
                          Colors.deepPurpleAccent,
                        ])),
                    child: TextWidget(
                      text: 'View Hotels',
                      color: Colors.white,
                      textSize: 15,
                      fontFamily: 'Cormorant',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => ViewRecomScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.pinkAccent,
                          Colors.deepPurpleAccent,
                        ])),
                    child: TextWidget(
                      text: 'View Recommendations',
                      color: Colors.white,
                      textSize: 15,
                      fontFamily: 'Cormorant',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => AddTour()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.pinkAccent,
                          Colors.deepPurpleAccent,
                        ])),
                    child: TextWidget(
                      text: 'Add tour',
                      color: Colors.white,
                      textSize: 15,
                      fontFamily: 'Cormorant',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => AddHotel()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.pinkAccent,
                          Colors.deepPurpleAccent,
                        ])),
                    child: TextWidget(
                      text: 'Add hotel',
                      color: Colors.white,
                      textSize: 15,
                      fontFamily: 'Cormorant',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => AddRecom()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(colors: [
                          Colors.pinkAccent,
                          Colors.deepPurpleAccent,
                        ])),
                    child: TextWidget(
                      text: 'Add Recommendations',
                      color: Colors.white,
                      textSize: 15,
                      fontFamily: 'Cormorant',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              Image.asset(
                'assets/images/AlmatyTour_logo.png',
                fit: BoxFit.fill,
              )
            ],
          ),
        ),
      ),
    );
  }
}
