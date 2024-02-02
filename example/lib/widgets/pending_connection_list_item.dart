import 'package:flutter/material.dart';

class PendingConnectionListItem extends StatelessWidget {
  final String deviceName;
  final Function action;
  const PendingConnectionListItem(
      {super.key, required this.deviceName, required this.action});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: InkWell(
          onTap: () {
            action();
          },
          child: SizedBox(
            width: 300,
            height: 100,
            child: Center(child: Text(deviceName)),
          ),
        ));
  }
}
