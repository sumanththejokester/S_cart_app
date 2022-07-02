// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_componets/staticsscreen.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

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

          double totalprice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalprice += item['orderqty'] * item['orderprice'];
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const AppBarTitle(title: 'Balance'),
              leading: const AppBarBackButton(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 20,
                ),
                StaticsButton2(
                    label: 'Total Balance',
                    value: totalprice,
                    img1: 'images/inapp/buttons.jpg',
                    img2: 'images/inapp/shadowr.png'),
                Center(
                  child: Container(
                    height: 75,
                    width: 200,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 13,
                          left: 15,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                height: 55,
                                width: 170,
                                child:
                                    Image.asset('images/inapp/buttonre.png')),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 41,
                            child: SizedBox(
                                //height: 280,
                                width: 120,
                                child: Image.asset(
                                  'images/inapp/shadowr.png',
                                  color: Colors.blueGrey,
                                ))),
                        const Positioned(
                          left: 60,
                          top: 21,
                          child: Center(
                            child: Text(
                              'WithDraw',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Acme'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          );
        });
  }
}
