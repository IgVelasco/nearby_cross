import 'package:flutter/material.dart';

class PendingConnectionListItem extends StatelessWidget {
  final String deviceName;
  final Function acceptAction;
  final Function rejectAction;
  const PendingConnectionListItem(
      {super.key,
      required this.deviceName,
      required this.acceptAction,
      required this.rejectAction});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text(deviceName)),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton.small(
                      heroTag: null,
                      onPressed: () {
                        rejectAction();
                      },
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.cancel_outlined),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      indent: 20,
                      endIndent: 0,
                    ),
                    FloatingActionButton.small(
                      heroTag: null,
                      onPressed: () {
                        acceptAction();
                      },
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
