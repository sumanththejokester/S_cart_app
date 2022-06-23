// ignore_for_file: unnecessary_const

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_componets/mystorescreen.dart';
import 'package:multi_store_app/main_screen/store.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

import '../dashboard_componets/balancescreen.dart';
import '../dashboard_componets/editbussinessscreen.dart';
import '../dashboard_componets/manageproducts.dart';
import '../dashboard_componets/staticsscreen.dart';
import '../dashboard_componets/suppliersordersscreen.dart';
import '../widgets/CupertinoDialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'DashBoard'),
        actions: [
          IconButton(
              onPressed: () {
                MyCupertinoAlertDialog.showMyCupertinoDialog(
                  context: context,
                  title: 'Log Out',
                  content: 'Sure you want to Log Out ?',
                  tapNo: () {
                    Navigator.pop(context);
                  },
                  tapYes: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/welcome_screen');
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              )),
        ],
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Store(
                          suppId: FirebaseAuth.instance.currentUser!.uid)));
            },
            child: const DashboardButtons(
              ButtonLabel: 'My Store',
              iconLabel: Icons.store,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SuppliersOrdersScreen()));
            },
            child: const DashboardButtons(
              ButtonLabel: 'Orders',
              iconLabel: Icons.shop,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditBussinessScreen()));
            },
            child: const DashboardButtons(
                ButtonLabel: 'Edit Profile', iconLabel: Icons.edit),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ManageProductsScreen()));
            },
            child: const DashboardButtons(
              ButtonLabel: 'Manage Products',
              iconLabel: Icons.settings,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BalanceScreen()));
            },
            child: const DashboardButtons(
                ButtonLabel: 'Balance', iconLabel: Icons.currency_rupee_sharp),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StaticsScreen()));
            },
            child: const DashboardButtons(
                ButtonLabel: 'Statics', iconLabel: Icons.show_chart),
          ),
        ],
      ),
    );
  }
}

class DashboardButtons extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String ButtonLabel;
  final IconData iconLabel;
  const DashboardButtons(
      // ignore: non_constant_identifier_names
      {Key? key,
      // ignore: non_constant_identifier_names
      required this.ButtonLabel,
      required this.iconLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [
              const Color.fromARGB(255, 189, 226, 241),
              Colors.blueGrey
            ])),
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.height * 0.6,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              iconLabel,
              color: Colors.blueGrey,
              size: 30,
            ),
            Text(
              ButtonLabel,
              style: TextStyle(color: Colors.blueGrey[900], fontSize: 25),
            ),
          ],
        )),
      ),
    );
  }
}
