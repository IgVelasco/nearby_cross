import 'package:flutter/material.dart';
import 'package:nearby_cross/types/item_type.dart';
import 'package:nearby_cross_example/viewmodels/advertiser_comunication_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/nc_app_bar.dart';
import '../widgets/nc_drawer.dart';

class AdvertiserComunicationScreen extends StatelessWidget {
  final Item connectedDevice;
  AdvertiserComunicationScreen(this.connectedDevice, {super.key});

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AdvertiserComunicationViewModel(
                connectedDevice["endpointId"]!)),
      ],
      child: Scaffold(
        appBar: const NCAppBar(),
        drawer: const NCDrawer(),
        body: Consumer<AdvertiserComunicationViewModel>(
          builder: (context, viewmodel, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Username: ${viewmodel.getConnectedDeviceName()}'),
              Text('Last message received: ${viewmodel.getLastMessage()}'),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                ),
                controller: _textFieldController, // Add this line
              ),
              ElevatedButton(
                onPressed: () {
                  String inputData = _textFieldController.text;
                  viewmodel.sendData(inputData);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
