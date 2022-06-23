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
    return Scaffold(
      body: _tabs[_SelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blueGrey[900],
        unselectedItemColor: Colors.grey,
        currentIndex: _SelectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "CATEGORY"),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: "STORES"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "DASHBOARD"),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "UPLOAD"),
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
