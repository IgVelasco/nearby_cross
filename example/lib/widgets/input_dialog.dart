import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross_example/models/app_model.dart';
import 'package:provider/provider.dart';

class InputDialog extends StatelessWidget {
  final String defaultUsername;
  static final Logger logger = Logger();
  const InputDialog(this.defaultUsername, {super.key});

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
            logger.i(textFieldController.text);
            Provider.of<AppModel>(context, listen: false)
                .changeUsername(textFieldController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
