import 'package:flutter/material.dart';
import 'package:quizify/Globals/constants.dart';

Future<void> showConfirm(
    {required BuildContext context,
    required String confirmation,
    required String buttonText,
    required Function onConfirm}) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return AlertDialog(
      title: Text(
        'Are you sure',
        style: style,
      ),
      content: Text(
        confirmation,
        style: style,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: style,
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await onConfirm();
          },
          child: Text(
            buttonText,
            style: style,
          ),
        ),
      ],
    );
  }));
}
