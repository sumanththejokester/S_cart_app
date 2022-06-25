import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/authscreenwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class EditBussinessScreen extends StatefulWidget {
  final dynamic data;
  const EditBussinessScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<EditBussinessScreen> createState() => _EditBussinessScreenState();
}

class _EditBussinessScreenState extends State<EditBussinessScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String storename;
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
          title: const AppBarTitle(title: 'Edit Store'),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Store Logo',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.data['storelogo']),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Button(
                                buttonlabel: 'Change',
                                onPressed: () {
                                  pickstorelogo();
                                },
                                buttonwidth: 0.3),
                            SizedBox(
                              height: 15,
                            ),
                            storeimageFile == null
                                ? SizedBox()
                                : Button(
                                    buttonlabel: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        storeimageFile = null;
                                      });
                                    },
                                    buttonwidth: 0.3),
                          ],
                        ),
                        storeimageFile == null
                            ? SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(storeimageFile!.path))),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        'Edit Bussiness Info',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 18),
                      child: TextFormField(
                        initialValue: widget.data['storename'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Valid Store Name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          storename = value!;
                        },
                        decoration: textformdecoration.copyWith(
                          labelText: 'Name',
                          hintText: 'Store Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 18),
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
                    SizedBox(
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
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  XFile? storeimageFile;
  dynamic _pickedStorelogoError;
  pickstorelogo() async {
    try {
      final pickedStorelogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        storeimageFile = pickedStorelogo;
      });
    } catch (e) {
      setState(() {
        _pickedStorelogoError = e;
      });
    }
  }

  late String storelogo;
  Future uploadStorelogo() async {
    if (storeimageFile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg');

        await ref.putFile(File(storeimageFile!.path));

        storelogo = await ref.getDownloadURL();
      } catch (e) {}
    } else {
      storelogo = widget.data['storelogo'];
    }
  }

  Future editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference,
          {'storename': storename, 'phone': phone, 'storelogo': storelogo});
    }).whenComplete(() => Navigator.pop(context));
  }

  savechanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStorelogo().whenComplete(() {
        editStoreData();
      });
    } else {
      MyMessageBuilder.showSnackBar(scaffoldKey, 'Fill Fields with Valid Info');
    }
  }
}
