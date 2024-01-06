import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../widgets/nc_app_bar.dart';
import '../widgets/nc_drawer.dart';
import '../models/app_model.dart';

class AdvertiserComunicationScreen extends StatelessWidget {
  final Item advertiser;
  AdvertiserComunicationScreen({super.key, required this.advertiser});

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NCAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<AppModel>(
              builder: (context, app, child) => Text(
                  'Running on: ${app.platformVersion} \n username: ${app.username}')),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Type something...',
            ),
            controller: _textFieldController, // Add this line
          ),
          ElevatedButton(
            onPressed: () {
              String inputData = _textFieldController.text;
              Provider.of<AppModel>(context, listen: false).sendData(inputData);
            },
            child: const Text('Send'),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () =>
                  Provider.of<AppModel>(context, listen: false).disconnect(),
              child: const Text('Disconnect'),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
