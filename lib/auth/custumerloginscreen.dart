// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/auth/forgotpasswordscreen.dart';

import '../widgets/authscreenwidgets.dart';

import '../widgets/snackbar.dart';

class CustumerLogin extends StatefulWidget {
  const CustumerLogin({Key? key}) : super(key: key);

  @override
  State<CustumerLogin> createState() => _CustumerLoginState();
}

class _CustumerLoginState extends State<CustumerLogin> {
  late String name;
  late String email;
  late String password;

  bool password_visibility = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool processing = false;

  void login() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        _formKey.currentState!.reset();

        Navigator.pushReplacementNamed(context, '/custumer_home_screen');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessageBuilder.showSnackBar(
              _scaffoldKey, 'No User found for that Email');
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });
          MyMessageBuilder.showSnackBar(_scaffoldKey, 'Wrong Password');
        }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeader(
                        headerlabel: 'Log In',
                      ),
                      const SizedBox(
                        height: 50,
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
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const resetPassword()));
                          },
                          child: const Text(
                            'Forgot Password ? ',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 16),
                          )),
                      Haveaccount(
                        actionlabel: 'Sign Up',
                        haveaccount: 'Don\'t Have An Account ? ',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/custumer_signup_screen');
                        },
                      ),
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.blueGrey))
                          : Authmainbutton(
                              buttonlabel: 'Log In',
                              onPressed: () {
                                login();
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
