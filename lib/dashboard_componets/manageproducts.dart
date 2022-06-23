import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbarwidgets.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Manage Products'),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
