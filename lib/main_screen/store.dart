import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_componets/editbussinessscreen.dart';
import 'package:multi_store_app/models/productmodels.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class Store extends StatefulWidget {
  final String? suppId;
  const Store({Key? key, required this.suppId}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 120,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.white,
              flexibleSpace: Image.asset(
                'images/inapp/coverimage1.jpg',
                fit: BoxFit.cover,
              ),
              title: Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            color: Color.fromARGB(255, 207, 216, 220)),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[100]!.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text(
                              data['storename'].toUpperCase(),
                              style: TextStyle(
                                  color: Colors.blueGrey[900],
                                  fontFamily: 'Caveat',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        data['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[100],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditBussinessScreen(
                                                    data: data,
                                                  )));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Edit...',
                                          style: TextStyle(
                                              color: Colors.blueGrey[900],
                                              fontSize: 18),
                                        ),
                                        Icon(
                                          Icons.edit,
                                          color: Colors.blueGrey[900],
                                        )
                                      ],
                                    )),
                              )
                            : Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.35,
                                decoration: BoxDecoration(
                                    color: following == false
                                        ? Colors.blueGrey[100]
                                        : Colors.blueGrey.withOpacity(0),
                                    borderRadius: BorderRadius.circular(25),
                                    border: following == false
                                        ? null
                                        : Border.all(
                                            color: Color.fromARGB(
                                                255, 207, 216, 220))),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      following = !following;
                                    });
                                  },
                                  child: following == true
                                      ? Text(
                                          'FOLLOWING',
                                          style: TextStyle(
                                              color: Colors.blueGrey[100],
                                              fontSize: 18),
                                        )
                                      : Text(
                                          'FOLLOW',
                                          style: TextStyle(
                                              color: Colors.blueGrey[900],
                                              fontSize: 18),
                                        ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _productsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text(
                        'This Store has no Items',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Acme',
                            letterSpacing: 1.5),
                      ));
                    }

                    return SingleChildScrollView(
                      child: StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return ProductModel(
                            products: snapshot.data!.docs[index],
                          );
                        },
                        staggeredTileBuilder: (context) =>
                            const StaggeredTile.fit(1),
                      ),
                    );
                  },
                ),
              ],
            ),
            floatingActionButton:
                data['sid'] == FirebaseAuth.instance.currentUser!.uid
                    ? null
                    : FloatingActionButton(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.whatsapp_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
          );
        }

        return const Center(child: const CircularProgressIndicator());
      },
    );
  }
}
