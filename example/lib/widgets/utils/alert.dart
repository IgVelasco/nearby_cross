import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final Icon icon;
  final String title;
  final String message;
  final double widthFactor;
  final double heightFactor;

  const Alert(
      {super.key,
      required this.title,
      required this.message,
      this.icon = const Icon(
        Icons.warning,
        size: 40,
      ),
      this.widthFactor = 0.8,
      this.heightFactor = 0.4});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          elevation: 10,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * widthFactor,
              maxHeight: constraints.maxHeight * heightFactor,
              minHeight: constraints.minHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            message,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
