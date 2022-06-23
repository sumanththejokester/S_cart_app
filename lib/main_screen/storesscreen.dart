import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screen/store.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Stores'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('suppliers').snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasData) {
            return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Store(
                                        suppId: snapshot.data!.docs[index]
                                            ['sid'],
                                      )));
                        },
                        child: Stack(children: [
                          SizedBox(
                            height: 260,
                            width: 260,
                            child: Image.asset(
                              'images/inapp/stores.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: 181,
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: Colors.white, width: 3)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    snapshot.data!.docs[index]['storelogo'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        child: Text(
                          snapshot.data!.docs[index]['storename'].toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'Caveat',
                              fontSize: 24,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                }),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 1));
          }
          return Text('no stores');
        },
      ),
    );
  }
}
