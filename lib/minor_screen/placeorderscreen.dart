import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/custumer_profile_components/addaddressscreen.dart';
import 'package:multi_store_app/minor_screen/addressbook.dart';
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
  late String sname;
  late String sphone;
  late String saddress;
  CollectionReference custumers =
      FirebaseFirestore.instance.collection('custumers');
  final Stream<QuerySnapshot> _addressStream = FirebaseFirestore.instance
      .collection('custumers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .where('default', isEqualTo: true)
      .limit(1)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double totalprice = context.watch<Cart>().totalprice;
    return StreamBuilder<QuerySnapshot>(
        stream: _addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
                child: const Center(child: CircularProgressIndicator()));
          }
          /* if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text(
              'No Saved Address!',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Acme',
                  letterSpacing: 1.5),
            ));
          }*/
          return Material(
            color: Colors.blueGrey[100],
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.blueGrey[100],
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.blueGrey[100],
                  leading: const AppBarBackButton(),
                  title: const AppBarTitle(title: 'Place Order'),
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
                      snapshot.data!.docs.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddAddress()));
                              },
                              child: Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'No Saved Address! \n      Add Address',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Acme',
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var custumer =
                                            snapshot.data!.docs[index];
                                        sname = custumer['firstname'] +
                                            custumer['lastname'];
                                        sphone = custumer['phone'];
                                        saddress = custumer['country'] +
                                            ', ' +
                                            custumer['state'] +
                                            ', ' +
                                            custumer['city'] +
                                            ', ' +
                                            custumer['faddress'];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddressBook()));
                                          },
                                          child: ListTile(
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${custumer['firstname']} ${custumer['lastname']}'
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Color.fromARGB(
                                                              255, 14, 55, 15)),
                                                    ),
                                                    Text(
                                                      custumer['phone'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              19,
                                                              12)),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${custumer['country']}, ${custumer['state']}'),
                                                    Text(
                                                        '${custumer['city']}, ${custumer['faddress']}'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child:
                              Consumer<Cart>(builder: ((context, cart, child) {
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
                                            padding: const EdgeInsets.all(5.0),
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
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.blueGrey[900],
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
                                                            color:
                                                                Colors.red[900],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        order.price
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red[900],
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
                          snapshot.data!.docs.isEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddAddress()))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentScreen(
                                          name: sname,
                                          phone: sphone,
                                          address: saddress)));
                        },
                        buttonwidth: 1),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
