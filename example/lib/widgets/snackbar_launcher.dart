import 'package:flutter/material.dart';

class SnackBarLauncher extends StatelessWidget {
  final String? message;

  const SnackBarLauncher(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _displaySnackBar(context, message: message));
    }
    // Placeholder container widget
    return Container();
  }

  void _displaySnackBar(BuildContext context, {@required String? message}) {
    final snackBar = SnackBar(content: Text(message!));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
