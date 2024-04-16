import 'package:admin_panel_tour_app/functions/global_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'text_widget.dart';

class RecomWidget extends StatefulWidget {
  const RecomWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _RecomWidgetState createState() => _RecomWidgetState();
}

class _RecomWidgetState extends State<RecomWidget> {
  String title = '';
  String address = '';
  String descriptions = '';
  String? imageUrl;
  String price = '0.0';
  String contacts = '';

  @override
  void initState() {
    getRecomData();
    super.initState();
  }

  Future<void> getRecomData() async {
    try {
      final DocumentSnapshot recomsDoc = await FirebaseFirestore.instance
          .collection('reck')
          .doc(widget.id)
          .get();
      if (recomsDoc == null) {
        return;
      } else {
        if (mounted) {
          setState(() {
            title = recomsDoc.get('title');
            imageUrl = recomsDoc.get('imageUrl');
            price = recomsDoc.get('price');
            address = recomsDoc.get('address');
            contacts = recomsDoc.get('contacts');
            descriptions = recomsDoc.get('description');
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.all(5.0),
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
            text: 'Title: $title',
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
            height: 2,
          ),
          TextWidget(
            text: 'Description: $descriptions',
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
                          .collection('reck')
                          .doc(widget.id)
                          .delete();
                      await Fluttertoast.showToast(
                          msg: 'Product has been deleted',
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
