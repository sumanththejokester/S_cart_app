// ignore_for_file: non_constant_identifier_names

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:multi_store_app/main_screen/cartscreen.dart';
import 'package:multi_store_app/main_screen/categoryscreen.dart';
import 'package:multi_store_app/main_screen/homescreen.dart';
import 'package:multi_store_app/main_screen/profilescreen.dart';
import 'package:multi_store_app/main_screen/storesscreen.dart';
import 'package:multi_store_app/provider/cartprovider.dart';
import 'package:provider/provider.dart';

class CustumerHomeScreen extends StatefulWidget {
  const CustumerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustumerHomeScreen> createState() => _CustumerHomeScreenState();
}

class _CustumerHomeScreenState extends State<CustumerHomeScreen> {
  int _SelectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    const CartScreen(),
    ProfileScreen(
      documentId: (FirebaseAuth.instance.currentUser!.uid),
    )
  ];
  @override
  Widget build(BuildContext context) {
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
                  showBadge:
                      context.read<Cart>().getItems.isEmpty ? false : true,
                  animationType: BadgeAnimationType.slide,
                  badgeColor: const Color.fromARGB(255, 152, 189, 205),
                  badgeContent: Text(
                    context.watch<Cart>().getItems.length.toString(),
                    style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  child: const Icon(Icons.shopping_cart)),
              label: "CART"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "PROFILE"),
        ],
        onTap: (index) {
          setState(() {
            _SelectedIndex = index;
          });
        },
      ),
    );
  }
}
