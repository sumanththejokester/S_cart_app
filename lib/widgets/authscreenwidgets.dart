import 'package:flutter/material.dart';

class Authmainbutton extends StatelessWidget {
  final String buttonlabel;
  final Function() onPressed;
  const Authmainbutton(
      {Key? key, required this.buttonlabel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Material(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(25),
          child: MaterialButton(
            minWidth: double.infinity,
            onPressed: onPressed,
            child: Text(
              buttonlabel,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[100]),
            ),
          )),
    );
  }
}

class Haveaccount extends StatelessWidget {
  final String haveaccount;
  final String actionlabel;
  final Function() onPressed;
  const Haveaccount(
      {Key? key,
      required this.haveaccount,
      required this.onPressed,
      required this.actionlabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveaccount,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              actionlabel,
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
      ],
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String headerlabel;
  const AuthHeader({Key? key, required this.headerlabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerlabel,
            style: TextStyle(
                color: Colors.blueGrey[900],
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(
                Icons.home_work,
                size: 40,
              ))
        ],
      ),
    );
  }
}

var textformdecoration = InputDecoration(
    labelText: 'Full Name',
    labelStyle: TextStyle(color: Colors.blueGrey[900]),
    hintText: 'Enter Your Full Name',
    hintStyle: TextStyle(color: Colors.blueGrey[900]?.withOpacity(0.7)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.blueGrey, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 207, 216, 220), width: 2)));

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$')
        .hasMatch(this);
  }
}
