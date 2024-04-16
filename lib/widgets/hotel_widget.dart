import 'package:admin_panel_tour_app/functions/global_method.dart';
import 'package:admin_panel_tour_app/widgets/edit_tour_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'text_widget.dart';

class HotelWidget extends StatefulWidget {
  const HotelWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _HotelWidgetState createState() => _HotelWidgetState();
}

class _HotelWidgetState extends State<HotelWidget> {
  String hotel_name = '';
  String address = '';
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
      final DocumentSnapshot hotelsDoc = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.id)
          .get();
      if (hotelsDoc == null) {
        return;
      } else {
        if (mounted) {
          setState(() {
            hotel_name = hotelsDoc.get('hotelName');
            imageUrl = hotelsDoc.get('imageUrl');
            price = hotelsDoc.get('price');
            address = hotelsDoc.get('address');
            contacts = hotelsDoc.get('contacts');
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
            text: 'Hotel name: $hotel_name',
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
            text: 'Location: $address',
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
                          .collection('hotels')
                          .doc(widget.id)
                          .delete();
                      await Fluttertoast.showToast(
                          msg: 'Hotel has been deleted',
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
