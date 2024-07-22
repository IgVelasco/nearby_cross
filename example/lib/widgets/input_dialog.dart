import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InputDialog extends StatelessWidget {
  final String defaultUsername;
  final Function(String) performAction;
  static final Logger logger = Logger();
  const InputDialog(this.defaultUsername, this.performAction, {super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();

    return AlertDialog(
      title: const Text('Change Username'),
      content: TextField(
        controller: textFieldController,
        decoration: InputDecoration(hintText: defaultUsername),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            performAction(textFieldController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
