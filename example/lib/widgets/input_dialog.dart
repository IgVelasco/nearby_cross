import 'package:flutter/material.dart';
import 'package:nearby_cross_example/models/app_model.dart';
import 'package:provider/provider.dart';

class InputDialog extends StatelessWidget {
  final String defaultUsername;
  const InputDialog(this.defaultUsername, {super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();

    return AlertDialog(
      title: Text('Change Username'),
      content: TextField(
        controller: textFieldController,
        decoration: InputDecoration(hintText: defaultUsername),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            print(textFieldController.text);
            Provider.of<AppModel>(context, listen: false)
                .changeUsername(textFieldController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
