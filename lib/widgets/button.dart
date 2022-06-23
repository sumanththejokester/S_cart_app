import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonlabel;
  final Function() onPressed;
  final double buttonwidth;
  const Button(
      {Key? key,
      required this.buttonlabel,
      required this.onPressed,
      required this.buttonwidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: MediaQuery.of(context).size.width * buttonwidth,
        decoration: BoxDecoration(
            color: Colors.blueGrey[700],
            borderRadius: BorderRadius.circular(15)),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            buttonlabel,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }
}
