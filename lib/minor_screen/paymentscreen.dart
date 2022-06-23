import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedvalue = 1;
  late String orderid;
  CollectionReference custumers =
      FirebaseFirestore.instance.collection('custumers');
  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
      max: 100,
      msg: 'Making Order...',
      msgFontSize: 20,
      msgColor: Color.fromARGB(255, 38, 50, 56),
      progressBgColor: Color.fromARGB(255, 207, 216, 220),
      progressValueColor: Color.fromARGB(255, 38, 50, 56),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalprice = context.watch<Cart>().totalprice;
    double shippingprice = context.watch<Cart>().totalprice * 0.07;
    double totalpaid = context.watch<Cart>().totalprice + shippingprice;
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
            return const Material(
              child: const Center(
                child: const CircularProgressIndicator(),
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
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(title: 'Payment'),
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
                          height: 140,
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Colors.blueGrey[900]),
                                      ),
                                      Text(
                                        (' ₹ ') + totalpaid.toStringAsFixed(2),
                                        style: TextStyle(
                                            color: Colors.red[900],
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Acme'),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Total : ',
                                        style: TextStyle(
                                            color: Colors.blueGrey[900]!
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        (' ₹ ') + totalprice.toStringAsFixed(2),
                                        style: TextStyle(
                                            color: Colors.blueGrey[900]!
                                                .withOpacity(0.6),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Acme'),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Shipping Cost : ',
                                        style: TextStyle(
                                            color: Colors.blueGrey[900]!
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        (' ₹ ') +
                                            shippingprice.toStringAsFixed(2),
                                        style: TextStyle(
                                            color: Colors.blueGrey[900]!
                                                .withOpacity(0.6),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Acme'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            child: Column(
                              children: [
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedvalue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedvalue = value!;
                                    });
                                  },
                                  title: const Text('Cash on Delivery'),
                                  selectedTileColor: Colors.blueGrey[900],
                                  activeColor: Colors.blueGrey[900],
                                  subtitle: const Text(
                                      'Pay during the time of Delivery'),
                                ),
                                RadioListTile(
                                    value: 2,
                                    groupValue: selectedvalue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedvalue = value!;
                                      });
                                    },
                                    title: const Text(
                                        'Pay via visa / Master Cart'),
                                    selectedTileColor: Colors.blueGrey[900],
                                    activeColor: Colors.blueGrey[900],
                                    subtitle: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Icon(Icons.payment_outlined),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 0, 7, 0),
                                          child: Icon(
                                              FontAwesomeIcons.ccMastercard),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Icon(FontAwesomeIcons.ccVisa),
                                        )
                                      ],
                                    )),
                                RadioListTile(
                                    value: 3,
                                    groupValue: selectedvalue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedvalue = value!;
                                      });
                                    },
                                    title: const Text('Pay through Wallet'),
                                    selectedTileColor: Colors.blueGrey[900],
                                    activeColor: Colors.blueGrey[900],
                                    subtitle: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(
                                              Icons.account_balance_wallet),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 7, 0),
                                          child:
                                              Icon(FontAwesomeIcons.googlePay),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(FontAwesomeIcons.paypal),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    height: 55,
                    color: Colors.blueGrey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Button(
                          buttonlabel:
                              'Confirm to Pay  ₹ ${totalpaid.toStringAsFixed(2)}',
                          onPressed: () {
                            if (selectedvalue == 1) {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                  context: context,
                                  builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 38.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Center(
                                                child: Text(
                                                  'Ordering Items Through \n     Cash on Delivery... ',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueGrey[900],
                                                      fontSize: 25,
                                                      fontFamily: 'Caveat',
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Button(
                                                  buttonlabel: 'Confirm Order',
                                                  onPressed: () async {
                                                    showProgress();
                                                    for (var item in context
                                                        .read<Cart>()
                                                        .getItems) {
                                                      CollectionReference
                                                          orderRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'orders');
                                                      orderid =
                                                          const Uuid().v4();
                                                      await orderRef
                                                          .doc(orderid)
                                                          .set({
                                                        'cid': data['cid'],
                                                        'custname':
                                                            data['name'],
                                                        'email': data['email'],
                                                        'address':
                                                            data['address'],
                                                        'phone': data['phone'],
                                                        'profileimage': data[
                                                            'profileimage'],
                                                        'sid': item.suppId,
                                                        'productid':
                                                            item.documentId,
                                                        'orderid': orderid,
                                                        'ordername': item.name,
                                                        'orderimage': item
                                                            .imagesUrl.first,
                                                        'orderqty': item.qty,
                                                        'orderprice': item.qty *
                                                            item.price,
                                                        'deliverystatus':
                                                            'preparing',
                                                        'deliverydate': '',
                                                        'orderdate':
                                                            DateTime.now(),
                                                        'paymentstatus':
                                                            'cash on delivery',
                                                        'orderreview': false,
                                                      }).whenComplete(() async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (transaction) async {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'products')
                                                                  .doc(item
                                                                      .documentId);
                                                          DocumentSnapshot
                                                              documentSnapshot =
                                                              await transaction.get(
                                                                  documentReference);
                                                          transaction.update(
                                                              documentReference,
                                                              {
                                                                'instock':
                                                                    documentSnapshot[
                                                                            'instock'] -
                                                                        item.qty
                                                              });
                                                        });
                                                      });
                                                    }
                                                    ;
                                                    context
                                                        .read<Cart>()
                                                        .clearCart();
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/custumer_home_screen'));
                                                  },
                                                  buttonwidth: 0.8)
                                            ],
                                          ),
                                        ),
                                      ));
                            } else if (selectedvalue == 2) {
                            } else if (selectedvalue == 3) {}
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
