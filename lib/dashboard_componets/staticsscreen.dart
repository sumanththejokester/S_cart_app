// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('orders')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(child: CircularProgressIndicator()));
          }
          num itemCount = 0;
          for (var item in snapshot.data!.docs) {
            itemCount = item['orderqty'];
          }
          double totalprice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalprice += item['orderqty'] * item['orderprice'];
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const AppBarTitle(title: 'Statics'),
              leading: const AppBarBackButton(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StaticsButton(
                  label: 'Sold Out',
                  value: snapshot.data!.docs.length,
                  img1: 'images/inapp/button.jpg',
                  img2: 'images/inapp/shadow.png',
                ),
                StaticsButton(
                  label: 'Item Count',
                  value: itemCount,
                  img1: 'images/inapp/button.jpg',
                  img2: 'images/inapp/shadow.png',
                ),
                StaticsButton2(
                    label: 'Total Balance',
                    value: totalprice,
                    img1: 'images/inapp/buttons.jpg',
                    img2: 'images/inapp/shadowr.png')
              ],
            ),
          );
        });
  }
}

class StaticsButton extends StatelessWidget {
  final String label;
  final dynamic value;
  final String img1;
  final String img2;
  const StaticsButton(
      {Key? key,
      required this.label,
      required this.value,
      required this.img1,
      required this.img2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontFamily: 'Acme', fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Center(
          child: Container(
            height: 150,
            width: 150,
            child: Stack(
              children: [
                Positioned(
                  bottom: 11,
                  left: 16,
                  child: Container(
                      height: 120, width: 120, child: Image.asset(img1)),
                ),
                Positioned(
                    bottom: 0,
                    left: 16,
                    child: SizedBox(
                        //height: 280,
                        width: 120,
                        child: Image.asset(img2, color: Colors.blueGrey))),
                Positioned(
                    //left: 75,
                    //top: 15,
                    child: AnimatedCounter(
                  count: value,
                  decimal: 0,
                  sign: '',
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StaticsButton2 extends StatelessWidget {
  final String label;
  final dynamic value;
  final String img1;
  final String img2;
  const StaticsButton2(
      {Key? key,
      required this.label,
      required this.value,
      required this.img1,
      required this.img2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontFamily: 'Acme', fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Center(
          child: Container(
            height: 150,
            width: 400,
            child: Stack(
              children: [
                Positioned(
                  bottom: 35,
                  left: 30,
                  child: Container(
                      height: 110, width: 340, child: Image.asset(img1)),
                ),
                Positioned(
                    bottom: 0,
                    left: 30,
                    child: SizedBox(
                        //height: 280,
                        width: 340,
                        child: Image.asset(
                          img2,
                          color: Colors.blueGrey,
                        ))),
                Positioned(
                    left: 125,
                    top: 38,
                    child:
                        AnimatedCounter(count: value, decimal: 2, sign: ' ₹  '))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int decimal;
  final dynamic count;
  final dynamic sign;
  const AnimatedCounter(
      {Key? key,
      required this.count,
      required this.decimal,
      required this.sign})
      : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
            child: Text(
              widget.sign.toString() +
                  _animation.value.toStringAsFixed(widget.decimal),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.blueGrey[100],
                  fontFamily: 'Acme'),
            ),
          );
        });
  }
}
