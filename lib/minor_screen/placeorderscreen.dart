import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screen/paymentscreen.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  CollectionReference custumers =
      FirebaseFirestore.instance.collection('custumers');

  @override
  Widget build(BuildContext context) {
    double totalprice = context.watch<Cart>().totalprice;
    return FutureBuilder<DocumentSnapshot>(
        future: custumers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String?, dynamic> data =
                snapshot.data!.data() as Map<String?, dynamic>;
            return Material(
              color: Colors.blueGrey[100],
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.blueGrey[100],
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.blueGrey[100],
                    leading: AppBarBackButton(),
                    title: AppBarTitle(title: 'Place Order'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      60,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(data['name']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Phone : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(data['phone']),
                                  ],
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Address : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text('${data['address']}'),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Consumer<Cart>(
                                builder: ((context, cart, child) {
                              return ListView.builder(
                                itemCount: cart.count,
                                itemBuilder: ((context, index) {
                                  final order = cart.getItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 2),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    order.imagesUrl[0]),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  order.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueGrey[900],
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (' ₹  '),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          order.price
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (' x '),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Text(
                                                          order.qty.toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            })),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.blueGrey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Button(
                          buttonlabel: 'Confirm ',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentScreen()));
                          },
                          buttonwidth: 1),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
