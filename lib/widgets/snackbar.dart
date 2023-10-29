import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar showErrorSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
// ... another snackbar
}