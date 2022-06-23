import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:multi_store_app/main_screen/supplierhome.dart';
import 'package:multi_store_app/widgets/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool processing = false;
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/inapp/welcome2.jpg'),
                fit: BoxFit.cover)),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('WELCOME',
                      textStyle: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme'),
                      colors: [
                        const Color.fromARGB(255, 6, 51, 74),
                        const Color.fromARGB(255, 26, 122, 170),
                        const Color.fromARGB(255, 60, 107, 130),
                        const Color.fromARGB(255, 122, 141, 149),
                        Colors.white
                      ]),
                  ColorizeAnimatedText('S  CART',
                      textStyle: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme'),
                      colors: [
                        const Color.fromARGB(255, 6, 51, 74),
                        const Color.fromARGB(255, 26, 122, 170),
                        const Color.fromARGB(255, 60, 107, 130),
                        const Color.fromARGB(255, 122, 141, 149),
                        Colors.white
                      ]),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              //const Text(
              //  'WELCOME',
              //  style: TextStyle(color: Colors.white, fontSize: 30),
              //),
              SizedBox(
                height: 120,
                width: 200,
                child: Image(
                  image: const AssetImage(
                    'images/inapp/app_logo.png',
                  ),
                  color: Colors.blueGrey[100],
                ),
              ),
              SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Acme'),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('BUY'),
                      RotateAnimatedText('SHOP'),
                      //RotateAnimatedText('DIFFERENT'),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
              ),
              //Text(
              //  'SHOP',
              //  style: TextStyle(color: Colors.white, fontSize: 30),
              //),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey[400]?.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(10))),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Suppliers Only',
                            style: TextStyle(
                                color: Color.fromARGB(255, 182, 212, 225),
                                fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[400]?.withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AnimatedLogo(controller: _controller),
                              Button(
                                  buttonlabel: 'Log In',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/supplier_login_screen');
                                  },
                                  buttonwidth: 0.25),
                              Button(
                                  buttonlabel: 'Sign Up',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/supplier_signup_screen');
                                  },
                                  buttonwidth: 0.35)
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[400]?.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(50))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button(
                              buttonlabel: 'Log In',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/custumer_login_screen');
                              },
                              buttonwidth: 0.25),
                          Button(
                              buttonlabel: 'Sign Up',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/custumer_signup_screen');
                              },
                              buttonwidth: 0.35),
                          AnimatedLogo(controller: _controller),
                        ],
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[400]?.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Loginbutton(
                        label: 'Google',
                        child: const Image(
                            image: AssetImage('images/inapp/google.jpg')),
                        onPressed: () {},
                      ),
                      Loginbutton(
                        label: 'Facebook',
                        child: const Image(
                            image: AssetImage('images/inapp/facebook.jpg')),
                        onPressed: () {},
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 207, 216, 220),
                            )
                          : Loginbutton(
                              label: 'Guest',
                              child: const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 207, 216, 220),
                                size: 50,
                              ),
                              onPressed: () async {
                                setState(() {
                                  processing = true;
                                });
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  _uid = FirebaseAuth.instance.currentUser!.uid;
                                  await anonymous.doc(_uid).set({
                                    'name': '',
                                    'email': '',
                                    'profileimage': '',
                                    'phone': '',
                                    'address': '',
                                    'cid': _uid
                                  });
                                });
                                Navigator.pushReplacementNamed(
                                    context, '/custumer_home_screen');
                              },
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image(
          image: const AssetImage(
            'images/inapp/loading.png',
          ),
          color: Colors.blueGrey[300],
          height: 50,
        ),
      ),
    );
  }
}

class Loginbutton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const Loginbutton(
      {Key? key,
      required this.child,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
