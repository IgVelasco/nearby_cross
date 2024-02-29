import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String text;
  final Icon icon;

  const Alert(
      {super.key, required this.title, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: ListTile(
                leading: icon,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(title),
                ),
                subtitle: Text(text),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: Color(0xff272727),
                ),
                horizontalTitleGap: 30,
              )),
            ],
          ),
        ));
  }
}
