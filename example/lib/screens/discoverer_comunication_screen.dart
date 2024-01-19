import 'package:flutter/material.dart';
import 'package:nearby_cross_example/viewmodels/discoverer_comunication_viewmodel.dart';

import 'package:provider/provider.dart';
import '../widgets/nc_app_bar.dart';
import '../models/app_model.dart';

class DiscovererComunicationScreen extends StatelessWidget {
  final Item connectedDevice;
  DiscovererComunicationScreen({super.key, required this.connectedDevice});

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => DiscovererComunicationViewModel(
                  connectedDevice["endpointId"]!))
        ],
        child: Scaffold(
          appBar: const NCAppBar(),
          body: Consumer<DiscovererComunicationViewModel>(
              builder: (context, viewModel, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                              'Username: ${viewModel.getConnectedDeviceName()}'),
                          Text(
                              'Message Received: ${viewModel.getLastMessage()}')
                        ],
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type something...',
                        ),
                        controller: _textFieldController, // Add this line
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String inputData = _textFieldController.text;
                          viewModel.sendData(inputData);
                        },
                        child: const Text('Send'),
                      ),
                    ],
                  )),
        ));
  }
}
