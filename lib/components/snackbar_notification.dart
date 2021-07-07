import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    ),
  );
}
