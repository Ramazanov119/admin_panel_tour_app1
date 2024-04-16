import 'package:admin_panel_tour_app/functions/global_method.dart';
import 'package:admin_panel_tour_app/widgets/edit_tour_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'text_widget.dart';

class TourWidget extends StatefulWidget {
  const TourWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _TourWidgetState createState() => _TourWidgetState();
}

class _TourWidgetState extends State<TourWidget> {
  String title = '';
  String location = '';
  String? imageUrl;
  String price = '0.0';
  String contacts = '';

  @override
  void initState() {
    getToursData();
    super.initState();
  }

  Future<void> getToursData() async {
    try {
      final DocumentSnapshot toursDoc = await FirebaseFirestore.instance
          .collection('tours')
          .doc(widget.id)
          .get();
      if (toursDoc == null) {
        return;
      } else {
        if (mounted) {
          setState(() {
            title = toursDoc.get('title');
            imageUrl = toursDoc.get('imageUrl');
            price = toursDoc.get('price');
            location = toursDoc.get('location');
            contacts = toursDoc.get('contacts');
          });
        }
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            imageUrl == null ? 'assets/images/blocked_seller.png' : imageUrl!,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.13,
          ),
          const SizedBox(
            height: 2,
          ),
          TextWidget(
            text: 'Tour name: $title',
            color: Colors.white,
            textSize: 20,
            fontFamily: 'Cormorant',
          ),
          const SizedBox(
            width: 7,
          ),
          TextWidget(
            text: 'Price: $price',
            color: Colors.white,
            textSize: 15,
            fontFamily: 'Cormorant',
          ),
          const SizedBox(
            height: 2,
          ),
          TextWidget(
            text: 'Location: $location',
            color: Colors.white,
            textSize: 15,
            fontFamily: 'Cormorant',
          ),
          const SizedBox(
            height: 2,
          ),
          TextWidget(
            text: 'Contacts: $contacts',
            color: Colors.white,
            textSize: 15,
            fontFamily: 'Cormorant',
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(25)),
            child: TextButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Delete?',
                    subtitle: 'Press okay to confirm',
                    fct: () async {
                      await FirebaseFirestore.instance
                          .collection('tours')
                          .doc(widget.id)
                          .delete();
                      await Fluttertoast.showToast(
                          msg: 'Tour has been deleted',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2);
                      Navigator.pop(context);
                    },
                    context: context);
              },
              child: TextWidget(
                text: 'Delete',
                color: Colors.white,
                textSize: 9,
                fontFamily: 'Cormorant',
                isTitle: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}
