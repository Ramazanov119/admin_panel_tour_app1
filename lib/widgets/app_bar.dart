import 'package:admin_panel_tour_app/authentication/login_screen.dart';
import 'package:admin_panel_tour_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class NavAppBar extends StatefulWidget with PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;

  NavAppBar({
    this.preferredSizeWidget,
  });

  @override
  State<NavAppBar> createState() => _NavAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _NavAppBarState extends State<NavAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.deepPurpleAccent,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomeScreen()));
        },
        child: TextWidget(
          text: 'Admin Almaty tour',
          color: Colors.white,
          textSize: 24,
          fontFamily: 'Cormorant',
          isTitle: true,
        ),
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginScreen())));
                    },
                    child: TextWidget(
                      text: 'Logout',
                      color: Colors.white,
                      textSize: 20,
                      fontFamily: 'Cormorant',
                      isTitle: true,
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
