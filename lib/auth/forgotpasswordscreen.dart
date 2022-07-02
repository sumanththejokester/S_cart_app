// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/authscreenwidgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({Key? key}) : super(key: key);

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  late String email;
  bool img = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();
  Future resetpassword1(String email) async {
    if (email != '') {
      if (_formkey.currentState!.validate()) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          setState(() {
            img = true;
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            MyMessageBuilder.showSnackBar(
                _scaffoldkey, 'No User found for that Email');
          }
        }
      }
    } else if (email == '') {
      MyMessageBuilder.showSnackBar(_scaffoldkey, 'Please Fill Valid Email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 200,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: AuthHeader(headerlabel: 'Reset Password'),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formkey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    onPressed: () {
                      resetpassword1(email);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        Text(
                          'Reset Password',
                          style: TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  )),
              img == true
                  ? SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                        child:
                            Image.asset('images/inapp/ForgotEmailNotify.png'),
                      ),
                    )
                  : const SizedBox(
                      height: 40,
                    ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
