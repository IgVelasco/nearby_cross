import 'package:flutter/material.dart';

class ComunicationMessage extends StatelessWidget {
  final String text;
  final bool received;
  final bool broadcast;
  const ComunicationMessage(
      {super.key,
      required this.text,
      required this.received,
      required this.broadcast});

  @override
  Widget build(BuildContext context) {
    var cardColor = broadcast
        ? Colors.red
        : received
            ? Colors.white
            : Colors.green;
    var rowAlignment =
        received ? MainAxisAlignment.start : MainAxisAlignment.end;
    var textAlignment = received ? Alignment.centerLeft : Alignment.centerRight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: rowAlignment,
        children: [
          Card(
              color: cardColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Align(
                alignment: textAlignment,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
