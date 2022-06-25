import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/authscreenwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileScreen extends StatefulWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String name;
  bool processing = false;
  late String phone;
  late String address;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Edit Profile'),
          leading: const AppBarBackButton(),
        ),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //        SizedBox(
                  //        height: 25,
                  //    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(widget.data['profileimage']),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button(
                              buttonlabel: 'Change',
                              onPressed: () {
                                pickdp();
                              },
                              buttonwidth: 0.3),
                          SizedBox(
                            height: 15,
                          ),
                          imageFile == null
                              ? SizedBox()
                              : Button(
                                  buttonlabel: 'Reset',
                                  onPressed: () {
                                    setState(() {
                                      imageFile = null;
                                    });
                                  },
                                  buttonwidth: 0.3),
                        ],
                      ),
                      imageFile == null
                          ? SizedBox()
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  FileImage(File(imageFile!.path))),
                    ],
                  ),
                  //       SizedBox(
                  //       height: 25,
                  //   ),
                ],
              ),
              Column(
                children: [
                  //       SizedBox(
                  //       height: 25,
                  //   ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 8),
                    child: TextFormField(
                      initialValue: widget.data['name'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Valid Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        name = value!;
                      },
                      decoration: textformdecoration.copyWith(
                        labelText: 'Name',
                        hintText: 'Profile Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 8),
                    child: TextFormField(
                      initialValue: widget.data['phone'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Valid Phone Number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        phone = value!;
                      },
                      decoration: textformdecoration.copyWith(
                        labelText: 'Phone',
                        hintText: 'Edit Phone number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 8),
                    child: TextFormField(
                      initialValue: widget.data['address'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Valid Adress';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        address = value!;
                      },
                      decoration: textformdecoration.copyWith(
                        labelText: 'Address',
                        hintText: 'Edit Address',
                      ),
                    ),
                  ),
                  //  SizedBox(
                  //  height: 25,
                  //),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                      buttonlabel: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonwidth: 0.3),
                  SizedBox(
                    width: 20,
                  ),
                  processing == true
                      ? Button(
                          buttonlabel: 'Saving...',
                          onPressed: () {},
                          buttonwidth: 0.5)
                      : Button(
                          buttonlabel: 'Save Changes',
                          onPressed: () {
                            savechanges();
                          },
                          buttonwidth: 0.5)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  dynamic _pickedlogoError;
  pickdp() async {
    try {
      final pickedlogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFile = pickedlogo;
      });
    } catch (e) {
      setState(() {
        _pickedlogoError = e;
      });
    }
  }

  late String logo;
  Future uploadlogo() async {
    if (imageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('cust-images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFile!.path));

        logo = await ref.getDownloadURL();
      } catch (e) {}
    } else {
      logo = widget.data['profileimage'];
    }
  }

  Future editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('custumers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'name': name,
        'phone': phone,
        'profileimage': logo,
        'address': address
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  savechanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadlogo().whenComplete(() {
        editStoreData();
      });
    } else {
      MyMessageBuilder.showSnackBar(scaffoldKey, 'Fill Fields with Valid Info');
    }
  }
}
