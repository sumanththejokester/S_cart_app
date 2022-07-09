import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/custumer_profile_components/addaddressscreen.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:multi_store_app/widgets/button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({Key? key}) : super(key: key);

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('custumers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: 'Address Book'),
        elevation: 0,
        leading: AppBarBackButton(),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: addressStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Material(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.data!.docs.isEmpty) {
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
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var custumer = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () async {
                        for (var item in snapshot.data!.docs) {
                          await FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection('custumers')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('address')
                                    .doc(item.id);
                            transaction
                                .update(documentReference, {'default': false});
                          });
                        }
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('custumers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('address')
                                  .doc(custumer['addressid']);
                          transaction
                              .update(documentReference, {'default': true});
                        });
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('custumers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid);

                          transaction.update(documentReference, {
                            'address':
                                '${custumer['country']} , ${custumer['state']} , ${custumer['city']} , ${custumer['faddress']}'
                          });
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            //    boxShadow: [
                            //    BoxShadow(
                            //    color: Colors.red.withOpacity(0.4),
                            //  spreadRadius: 2,
                            //blurRadius: 8,
                            //),
                            //],
                            //color: Colors.blueGrey[100],
                            gradient: LinearGradient(colors: [
                              Colors.blueGrey.withOpacity(0.4),
                              Color.fromARGB(255, 15, 113, 162)
                                  .withOpacity(0.4),
                            ]),
                            border: Border.all(
                                color: const Color.fromARGB(255, 38, 50, 56)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListTile(
                            trailing: custumer['default'] == true
                                ? Icon(Icons.home_sharp)
                                : null,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${custumer['firstname']} ${custumer['lastname']}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 14, 55, 15)),
                                    ),
                                    Text(
                                      custumer['phone'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 112, 19, 12)),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
                    );
                  });
            },
          )),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Button(
                buttonlabel: 'Add New Address',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddAddress()));
                },
                buttonwidth: 0.7),
          )
        ],
      )),
    );
  }
}
