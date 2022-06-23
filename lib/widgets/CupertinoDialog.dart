// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class MyCupertinoAlertDialog {
  static void showMyCupertinoDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required Function() tapNo,
      required Function() tapYes}) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: tapNo,
                ),
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  isDestructiveAction: true,
                  onPressed: tapYes,
                )
              ],
            ));
  }
}
