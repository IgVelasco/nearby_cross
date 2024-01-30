import 'package:flutter/material.dart';
import 'package:nearby_cross_example/viewmodels/advertiser_comunication_viewmodel.dart';

import 'package:provider/provider.dart';
import '../widgets/nc_app_bar.dart';

class AdvertiserComunicationScreen extends StatelessWidget {
  AdvertiserComunicationScreen({super.key});

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => AdvertiserComunicationViewModel())
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: const NCAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<AdvertiserComunicationViewModel>(
                  builder: (context, viewModel, child) => Column(
                        children: [
                          Text(
                              'Last message username: ${viewModel.getLastMessageDeviceName()}'),
                          Text(
                              'Message Received: ${viewModel.getLastMessage()}')
                        ],
                      )),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                ),
                controller: _textFieldController, // Add this line
              ),
              ElevatedButton(
                onPressed: () {
                  String inputData = _textFieldController.text;
                  Provider.of<AdvertiserComunicationViewModel>(context,
                          listen: false)
                      .sendDataToDevices(inputData);
                },
                child: const Text('Send'),
              ),
            ],
          ),
        );
      },
    );
  }
}
