import 'package:flutter/material.dart';

class MyMessageBuilder {
  static void showSnackBar(var _scaffoldKey, String message) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: TextStyle(color: Colors.blueGrey[100]),
      ),
      backgroundColor: Colors.blueGrey[900],
    ));
  }
}
