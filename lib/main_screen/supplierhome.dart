import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:multi_store_app/main_screen/categoryscreen.dart';
import 'package:multi_store_app/main_screen/dashboardscreen.dart';
import 'package:multi_store_app/main_screen/homescreen.dart';
import 'package:multi_store_app/main_screen/storesscreen.dart';
import 'package:multi_store_app/main_screen/uploadproductscreen.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  // ignore: non_constant_identifier_names
  int _SelectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    StoresScreen(),
    DashboardScreen(),
    UploadProduct(),
  ];
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('deliverystatus', isEqualTo: 'preparing')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(child: CircularProgressIndicator()));
          }
          return Scaffold(
            body: _tabs[_SelectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Colors.blueGrey[900],
              unselectedItemColor: Colors.grey,
              currentIndex: _SelectedIndex,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "HOME",
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "CATEGORY"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.shop), label: "STORES"),
                BottomNavigationBarItem(
                    icon: Badge(
                        showBadge: snapshot.data!.docs.isEmpty ? false : true,
                        animationType: BadgeAnimationType.slide,
                        badgeColor: const Color.fromARGB(255, 152, 189, 205),
                        badgeContent: Text(
                          snapshot.data!.docs.length.toString(),
                          style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        child: const Icon(Icons.dashboard)),
                    label: "DASHBOARD"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.upload), label: "UPLOAD"),
              ],
              onTap: (index) {
                setState(() {
                  _SelectedIndex = index;
                });
              },
            ),
          );
        });
  }
}
