import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:multi_store_app/widgets/CupertinoDialog.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class CustumerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustumerOrderModel({Key? key, required this.order}) : super(key: key);

  @override
  State<CustumerOrderModel> createState() => _CustumerOrderModelState();
}

class _CustumerOrderModelState extends State<CustumerOrderModel> {
  late String comment;
  late double rate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(10)),
        child: ExpansionTile(
          title: Container(
            constraints:
                BoxConstraints(maxHeight: 80, maxWidth: double.infinity),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.order['orderimage']),
                  ),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.order['ordername'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text(
                                (' ₹  '),
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                widget.order['orderprice'].toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                (' x '),
                                style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                widget.order['orderqty'].toString(),
                                style: TextStyle(
                                    color: Colors.green[900],
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('See More..'),
              widget.order['deliverystatus'] == ''
                  ? Text(
                      'Yet to Deliver your order',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  : Text(
                      widget.order['deliverystatus'],
                      style: TextStyle(color: Colors.green[900]),
                    )
            ],
          ),
          children: [
            Container(
              //  height: 225,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.order['deliverystatus'] == 'delivered'
                      ? Colors.green.withOpacity(0.2)
                      : widget.order['deliverystatus'] == 'shipping'
                          ? Colors.orangeAccent.withOpacity(0.2)
                          : widget.order['deliverystatus'] == ''
                              ? Colors.redAccent.withOpacity(0.2)
                              : Colors.blueGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name :  ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          widget.order['custname'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Phone : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          widget.order['phone'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Email : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          widget.order['email'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Address : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          widget.order['address'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Payment Status : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          widget.order['paymentstatus'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Delivery Status : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          widget.order['deliverystatus'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.green[900]),
                        ),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping' ||
                            widget.order['deliverystatus'] == '' ||
                            widget.order['deliverystatus'] == 'preparing'
                        ? Row(
                            children: [
                              Text(
                                'Estimated Delivery On  : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Caveat',
                                    fontSize: 18),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(widget.order['orderdate'].toDate())
                                    .toString(),
                                style: TextStyle(
                                    fontFamily: 'Acme',
                                    color: Colors.green[900]),
                              ),
                            ],
                          )
                        : Text(''),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        widget.order['deliverystatus'] == 'delivered' &&
                                widget.order['orderreview'] == false
                            ? TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Material(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                ),
                                                RatingBar.builder(
                                                  initialRating: 3,
                                                  itemCount: 5,
                                                  allowHalfRating: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    switch (index) {
                                                      case 0:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_very_dissatisfied,
                                                          color: Colors.red,
                                                        );
                                                      case 1:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_dissatisfied,
                                                          color:
                                                              Colors.redAccent,
                                                        );
                                                      case 2:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_neutral,
                                                          color: Colors.amber,
                                                        );
                                                      case 3:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_satisfied,
                                                          color:
                                                              Colors.lightGreen,
                                                        );
                                                      case 4:
                                                        return Icon(
                                                          Icons
                                                              .sentiment_very_satisfied,
                                                          color: Colors.green,
                                                        );
                                                    }
                                                    return Text('');
                                                  },
                                                  onRatingUpdate: (rating) {
                                                    rate = rating;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: TextField(
                                                    onChanged: ((value) {
                                                      comment = value;
                                                    }),
                                                    decoration: InputDecoration(
                                                        labelText: 'Review',
                                                        hintText:
                                                            'Enter Your Review ',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .blueGrey[900]),
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .blueGrey[900]
                                                                ?.withOpacity(
                                                                    0.7)),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    15)),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    15),
                                                            borderSide: const BorderSide(
                                                                color: Colors.blueGrey,
                                                                width: 1)),
                                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color.fromARGB(255, 161, 188, 198), width: 2))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Button(
                                                          buttonlabel: 'Cancel',
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          buttonwidth: 0.3),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Button(
                                                          buttonlabel: 'Save',
                                                          onPressed: () async {
                                                            CollectionReference
                                                                collRef =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'products')
                                                                    .doc(widget
                                                                            .order[
                                                                        'productid'])
                                                                    .collection(
                                                                        'reviews');
                                                            await collRef
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .set({
                                                              'name': widget
                                                                      .order[
                                                                  'custname'],
                                                              'email':
                                                                  widget.order[
                                                                      'email'],
                                                              'rate': rate,
                                                              'comment':
                                                                  comment,
                                                              'profileimage':
                                                                  widget.order[
                                                                      'profileimage']
                                                            }).whenComplete(
                                                                    () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .runTransaction(
                                                                      (transaction) async {
                                                                DocumentReference
                                                                    documentReference =
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'orders')
                                                                        .doc(widget
                                                                            .order['orderid']);
                                                                transaction.update(
                                                                    documentReference,
                                                                    {
                                                                      'orderreview':
                                                                          true
                                                                    });
                                                              });
                                                            });

                                                            await Future.delayed(
                                                                    Duration(
                                                                        microseconds:
                                                                            100))
                                                                .whenComplete(() =>
                                                                    Navigator.pop(
                                                                        context));
                                                          },
                                                          buttonwidth: 0.3),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ));
                                },
                                child: Text('Write Review'))
                            : Text(''),
                        widget.order['deliverystatus'] == 'delivered' &&
                                widget.order['orderreview'] == true
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.blue[900],
                                  ),
                                  Text(
                                    'Review Added',
                                    style: TextStyle(color: Colors.blue[900]),
                                  )
                                ],
                              )
                            : Text('')
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
