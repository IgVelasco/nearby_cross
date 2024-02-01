import 'package:flutter/material.dart';

class PendingConnectionListItem extends StatelessWidget {
  final String deviceName;
  const PendingConnectionListItem(this.deviceName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: SizedBox(
        width: 300,
        height: 100,
        child: Center(child: Text(deviceName)),
      ),
    );
  }
}
