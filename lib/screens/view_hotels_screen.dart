import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/hotel_widget.dart';
import '../widgets/text_widget.dart';

class ViewHotelsScreen extends StatelessWidget {
  const ViewHotelsScreen({Key? key, this.isInMain = true}) : super(key: key);
  final bool isInMain;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - 24) / 2;
    final double itemWidth = size.width / 2;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 600,
            decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Your store is empty',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cormorant',
                      fontSize: 20),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          }
        }
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0,
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
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: TextWidget(
                  text: 'View hotels',
                  color: Colors.white,
                  textSize: 24,
                  fontFamily: 'Cormorant'),
              centerTitle: false,
            ),
            body: AlignedGridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 13,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return HotelWidget(
                    id: snapshot.data!.docs[index]['id'],
                  );
                }));
      },
    );
  }
}
