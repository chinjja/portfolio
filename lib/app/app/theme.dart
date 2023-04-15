import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  void showSnackbarOk(String text) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: '확인',
            onPressed: () {
              ScaffoldMessenger.of(this).hideCurrentSnackBar();
            }),
      ));
  }
}
