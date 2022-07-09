import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/minor_screen/addressbook.dart';
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
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Profile Photo',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 60,
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
                            const SizedBox(
                              height: 25,
                            ),
                            imageFile == null
                                ? const SizedBox()
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
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(imageFile!.path))),
                      ],
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Edit Personal Info',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 14),
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
                          horizontal: 28.0, vertical: 14),
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressBook()));
                      },
                      child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 8),
                          child: Text(
                            '👉 Add Address / Change Default Address',
                            style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 17,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                    const SizedBox(
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
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  // ignore: unused_field
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
        // ignore: empty_catches
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
