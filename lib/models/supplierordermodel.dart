import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  const SupplierOrderModel({Key? key, required this.order}) : super(key: key);

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
                const BoxConstraints(maxHeight: 80, maxWidth: double.infinity),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(order['orderimage']),
                  ),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        order['ordername'],
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
                                order['orderprice'].toStringAsFixed(2),
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
                                order['orderqty'].toString(),
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
              const Text('See More..'),
              order['deliverystatus'] == ''
                  ? const Text(
                      'Yet to Deliver your order',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  : Text(
                      order['deliverystatus'],
                      style: TextStyle(color: Colors.green[900]),
                    )
            ],
          ),
          children: [
            Container(
              //  height: 225,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Name :  ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          order['custname'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Phone : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          order['phone'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Email : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          order['email'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Address : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          order['address'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.blueGrey[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Payment Status : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          order['paymentstatus'],
                          style: const TextStyle(
                              fontFamily: 'Acme', color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Delivery Status : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          order['deliverystatus'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.green[900]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Order Date : ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Caveat',
                              fontSize: 18),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(order['orderdate'].toDate())
                              .toString(),
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.green[900]),
                        ),
                      ],
                    ),
                    order['deliverystatus'] == 'delivered'
                        ? const Text('')
                        : Row(
                            children: [
                              const Text(
                                'Change Delivery Status to:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Caveat',
                                    fontSize: 18),
                              ),
                              order['deliverystatus'] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now()
                                                .add(const Duration(days: 365)),
                                            onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['orderid'])
                                              .update({
                                            'deliverystatus': 'shipping',
                                            'deliverydate': date
                                          });
                                        });
                                      },
                                      child: const Text('shipping?'))
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order['orderid'])
                                            .update({
                                          'deliverystatus': 'delivered'
                                        });
                                      },
                                      child: const Text('delivered?'))
                            ],
                          ),
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
