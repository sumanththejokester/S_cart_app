import 'package:flutter/material.dart';

class CustumerOrderModel extends StatelessWidget {
  final dynamic order;
  const CustumerOrderModel({Key? key, required this.order}) : super(key: key);

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
              Text('See More..'),
              order['deliverystatus'] == ''
                  ? Text(
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
                  color: order['deliverystatus'] == 'delivered'
                      ? Colors.green.withOpacity(0.2)
                      : order['deliverystatus'] == 'shipping'
                          ? Colors.orangeAccent.withOpacity(0.2)
                          : order['deliverystatus'] == ''
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
                          order['custname'],
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
                          order['phone'],
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
                          order['email'],
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
                          order['address'],
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
                          order['paymentstatus'],
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
                          order['deliverystatus'],
                          style: TextStyle(
                              fontFamily: 'Acme', color: Colors.green[900]),
                        ),
                      ],
                    ),
                    order['deliverystatus'] == 'shipping' ||
                            order['deliverystatus'] == '' ||
                            order['deliverystatus'] == 'preparing'
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
                                order['deliverydate'],
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
                        order['deliverystatus'] == 'delivered' &&
                                order['orderreview'] == false
                            ? TextButton(
                                onPressed: () {}, child: Text('Write Review'))
                            : Row(
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
