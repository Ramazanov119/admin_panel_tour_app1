import 'dart:io';

import 'package:admin_panel_tour_app/screens/loading_manager.dart';
import 'package:admin_panel_tour_app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../functions/global_method.dart';
import '../widgets/buttons.dart';

class AddTour extends StatefulWidget {
  const AddTour({Key? key}) : super(key: key);

  @override
  _AddTourState createState() => _AddTourState();
}

class _AddTourState extends State<AddTour> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController,
      _priceController,
      _locationController,
      _contactsController;
  int _groupValue = 1;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  @override
  void initState() {
    _contactsController = TextEditingController();
    _locationController = TextEditingController();
    _priceController = TextEditingController();
    _titleController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _priceController.dispose();
      _titleController.dispose();
      _contactsController.dispose();
      _locationController.dispose();
    }
    super.dispose();
  }

  bool _isLoading = false;
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Please pick up an image', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });

        final ref = FirebaseStorage.instance
            .ref()
            .child('tourImages')
            .child('$_uuid.jpg');
        if (kIsWeb) {
          await ref.putData(webImage);
        } else {
          await ref.putFile(_pickedImage!);
        }
        imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('tours').doc(_uuid).set({
          'id': _uuid,
          'title': _titleController.text,
          'price': _priceController.text,
          'location': _locationController.text,
          'contacts': _contactsController.text,
          'imageUrl': imageUrl.toString(),
          'createdAt': Timestamp.now(),
        });
        _clearForm();
        Fluttertoast.showToast(
          msg: "Product uploaded succefully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    _contactsController.clear();
    _locationController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldColor = Colors.transparent;
    Size size = MediaQuery.of(context).size;

    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
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
              text: 'Add tour',
              color: Colors.white,
              textSize: 24,
              fontFamily: 'Cormorant'),
          centerTitle: false,
        ),
        body: LoadingManager(
          isLoading: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: size.width > 650 ? 800 : size.width,
                        color: Color.fromARGB(160, 0, 0, 0),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextWidget(
                                text: 'Tour name*',
                                textSize: 30,
                                color: Colors.white,
                                isTitle: true,
                                fontFamily: 'Cormorant',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontFamily: 'Cormorant', fontSize: 18),
                                  controller: _titleController,
                                  key: const ValueKey('Title'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: 'Price in KZT*',
                                            textSize: 30,
                                            color: Colors.white,
                                            isTitle: true,
                                            fontFamily: 'Cormorant',
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: TextFormField(
                                                style: TextStyle(
                                                    fontFamily: 'Cormorant',
                                                    fontSize: 18),
                                                controller: _priceController,
                                                key: const ValueKey('Price \$'),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Price is missed';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextWidget(
                                            text: 'Location*',
                                            textSize: 30,
                                            color: Colors.white,
                                            fontFamily: 'Cormorant',
                                            isTitle: true,
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                              width: 100,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontFamily: 'Cormorant',
                                                        fontSize: 18),
                                                    controller:
                                                        _locationController,
                                                    key: const ValueKey(
                                                        'location'),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Location is missed';
                                                      }
                                                      return null;
                                                    },
                                                  ))),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextWidget(
                                            text: 'Contact*',
                                            textSize: 30,
                                            color: Colors.white,
                                            isTitle: true,
                                            fontFamily: 'Cormorant',
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                              width: 100,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                        fontFamily: 'Cormorant',
                                                        fontSize: 18),
                                                    controller:
                                                        _contactsController,
                                                    key: const ValueKey(
                                                        'Contacts'),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Contacts is missed';
                                                      }
                                                      return null;
                                                    },
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'[0-9.]')),
                                                    ],
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Image to be picked code is here
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          height: size.width > 650
                                              ? 350
                                              : size.width * 0.45,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: _pickedImage == null
                                              ? dottedBorder(color: Colors.blue)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: kIsWeb
                                                      ? Image.memory(webImage,
                                                          fit: BoxFit.fill)
                                                      : Image.file(
                                                          _pickedImage!,
                                                          fit: BoxFit.fill),
                                                )),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _pickedImage = null;
                                                  webImage = Uint8List(8);
                                                });
                                              },
                                              child: TextWidget(
                                                text: 'Clear',
                                                color: Colors.red,
                                                textSize: 30,
                                                fontFamily: 'Cormorant',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: TextWidget(
                                                text: 'Update image',
                                                color: Colors.blue,
                                                textSize: 30,
                                                fontFamily: 'Cormorant',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonsWidget(
                                      onPressed: () {
                                        _clearForm();
                                      },
                                      text: 'Clear form',
                                      icon: Icons.dangerous_outlined,
                                      backgroundColor: Colors.red.shade300,
                                    ),
                                    ButtonsWidget(
                                      onPressed: () {
                                        _uploadForm();
                                      },
                                      text: 'Upload',
                                      icon: Icons.upload_file_outlined,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: Colors.white,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() {
                      _pickImage();
                    }),
                    child: TextWidget(
                      text: 'Choose an image',
                      color: Colors.blue,
                      textSize: 20,
                      fontFamily: 'Cormorant',
                    ))
              ],
            ),
          )),
    );
  }
}
