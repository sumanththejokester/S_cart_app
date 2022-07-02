import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/searchmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueGrey[100],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: CupertinoSearchTextField(
            autofocus: true,
            backgroundColor: Colors.white,
            onChanged: ((value) {
              setState(() {
                search = value;
              });
            }),
          ),
        ),
        body: search == ''
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[300],
                      borderRadius: BorderRadius.circular(15)),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.search_sharp,
                        color: Colors.blueGrey[900],
                      ),
                      Text(
                        'Search For Products...',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontFamily: 'Acme',
                            fontSize: 22),
                      )
                    ],
                  ),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  final result = snapshot.data!.docs.where(
                    (element) => element['productname'].contains(search),
                  );
                  return ListView(
                    children: result.map((e) => SearchModel(e: e)).toList(),
                  );
                }));
  }
}
