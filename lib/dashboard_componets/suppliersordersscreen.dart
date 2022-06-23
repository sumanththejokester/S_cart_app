// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class SuppliersOrdersScreen extends StatelessWidget {
  const SuppliersOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(title: 'Supplier Orders'),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
