import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class CustumerOrdersScreen extends StatelessWidget {
  const CustumerOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'My Orders'),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text(
              'No Active Orders ',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Acme',
                  letterSpacing: 1.5),
            ));
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data!.docs[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      title: Container(
                        constraints: BoxConstraints(
                            maxHeight: 80, maxWidth: double.infinity),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Container(
                                constraints:
                                    BoxConstraints(maxHeight: 80, maxWidth: 80),
                                child: Image.network(order['orderimage']),
                              ),
                            ),
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                            order['orderprice']
                                                .toStringAsFixed(2),
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
                      subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Text('See More..'), Text('Delivery:')],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
