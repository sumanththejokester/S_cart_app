// ignore_for_file: prefer_const_constructors, unused_field, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

import '../widgets/authscreenwidgets.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/snackbar.dart';

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({Key? key}) : super(key: key);

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  late String storename;
  late String email;
  late String password;
  late String _uid;

  late String storelogo;
  bool password_visibility = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool processing = false;

  XFile? _imageFile;
  dynamic _pickedImageError;

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  void _pickimage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('supp-images/$email.jpg');

          await ref.putFile(File(_imageFile!.path));
          _uid = FirebaseAuth.instance.currentUser!.uid;
          storelogo = await ref.getDownloadURL();

          await suppliers.doc(_uid).set({
            'storename': storename,
            'email': email,
            'storelogo': storelogo,
            'phone': '',
            'coverimage': '',
            'sid': _uid
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
          Navigator.pushReplacementNamed(context, '/supplier_login_screen');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MyMessageBuilder.showSnackBar(
                _scaffoldKey, 'Password provided is weak');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MyMessageBuilder.showSnackBar(
                _scaffoldKey, 'An Account already exists for that email');
          }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageBuilder.showSnackBar(_scaffoldKey, 'Please Pick Image');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageBuilder.showSnackBar(_scaffoldKey, 'Please Fill All Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthHeader(
                        headerlabel: 'Sign Up',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.blueGrey[100],
                                backgroundImage: _imageFile == null
                                    ? null
                                    : FileImage(File(_imageFile!.path)),
                              ),
                              Positioned(
                                right: -16,
                                bottom: 0,
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        primary: Colors.white,
                                        backgroundColor:
                                            Colors.blueGrey[50]?.withOpacity(1),
                                      ),
                                      onPressed: () {
                                        _pickimage();
                                      },
                                      child: Icon(
                                        Icons.photo,
                                        color: Colors.blueGrey[200],
                                        size: 22,
                                      )
                                      //SvgPicture.asset("images/inapp/Camera_Icon.svg"),

                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            }),
                            onChanged: (value) {
                              storename = value;
                            },
                            //controller: _namecontroller,
                            decoration: textformdecoration.copyWith(
                                labelText: 'Full Name',
                                hintText: 'Enter Your Full Name')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              } else if (value.isValidEmail() == false) {
                                return 'Please enter Valid Email';
                              } else if (value.isValidEmail() == true) {
                                return null;
                              }
                              return null;
                            }),
                            onChanged: (value) {
                              email = value;
                            },
                            //controller: _emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: textformdecoration.copyWith(
                                labelText: 'Email Address',
                                hintText: 'Enter Your Email')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: TextFormField(
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password is too weak';
                              } else if (value.length >= 6) {
                                return null;
                              }
                              return null;
                            }),
                            onChanged: (value) {
                              password = value;
                            },
                            //controller: _passwordcontroller,
                            obscureText: password_visibility,
                            decoration: textformdecoration.copyWith(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        password_visibility =
                                            !password_visibility;
                                      });
                                    },
                                    icon: Icon(
                                      password_visibility
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.blueGrey,
                                    )),
                                labelText: 'Password',
                                hintText: 'Enter Your Password')),
                      ),
                      Haveaccount(
                        actionlabel: 'Log In',
                        haveaccount: 'Already Have An Account ? ',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_login_screen');
                        },
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.blueGrey,
                            )
                          : Authmainbutton(
                              buttonlabel: 'Sign Up',
                              onPressed: () {
                                signUp();
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//final TextEditingController _namecontroller = TextEditingController();
//final TextEditingController _emailcontroller = TextEditingController();
//final TextEditingController _passwordcontroller = TextEditingController();
