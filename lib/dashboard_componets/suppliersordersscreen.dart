// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_componets/supplierorderscomponents.dart/delivered.dart';
import 'package:multi_store_app/dashboard_componets/supplierorderscomponents.dart/preparing.dart';
import 'package:multi_store_app/dashboard_componets/supplierorderscomponents.dart/shipping.dart';
import 'package:multi_store_app/main_screen/homescreen.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class SuppliersOrdersScreen extends StatelessWidget {
  const SuppliersOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: AppBarTitle(title: 'Orders'),
          leading: const AppBarBackButton(),
          bottom: TabBar(
             indicatorColor: Colors.blueGrey,
              tabs: const [
                RepeatedTab(label: 'Preparing'),
                RepeatedTab(label: 'Shipping'),
                RepeatedTab(label: 'Delivered')
              ]),
        ),
        body:
            TabBarView(children: const [Preparing(), Shipping(), Delivered()]),
      ),
    );
  }
}
