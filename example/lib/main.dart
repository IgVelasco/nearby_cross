import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:nearby_cross/viewmodels/advertiser_viewmodel.dart';
import 'package:nearby_cross/viewmodels/discoverer_viewmodel.dart';
import 'package:provider/provider.dart';
import 'models/app_model.dart';
import 'widgets/nc_drawer.dart';

import 'widgets/nc_app_bar.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) {
        var appModel = AppModel();
        appModel.initPlatformState();
        return appModel;
      }),
      ChangeNotifierProvider(create: (context) => AdvertiserViewModel()),
      ChangeNotifierProvider(create: (context) => DiscovererViewModel())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var logger = Logger();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _deviceName = TextEditingController();
  String _message = '';

  bool _connectionStarted = false;
  String _connectedEpName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final advertiserViewModel = Provider.of<AdvertiserViewModel>(context);
    final discovererViewModel = Provider.of<DiscovererViewModel>(context);

    if (advertiserViewModel.getPlatformVersion() == null) {
      advertiserViewModel.findPlatformVersion();
    }

    void startDiscovery() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await discovererViewModel
            .requestPermissions(); // Can also be advertiser
        await discovererViewModel.startDiscovering(deviceName);
      } catch (e) {
        logger.e('Error starting discovery: $e');
      }
    }

    void advertise() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await advertiserViewModel
            .requestPermissions(); // Can also be discoverer
        await advertiserViewModel.startAdvertising(deviceName);
      } catch (e) {
        logger.e('Error starting advertising: $e');
      }
    }

    void disconnect() async {
      try {
        await advertiserViewModel.disconnect();
        await discovererViewModel.disconnect();
        setState(() {
          _message = "";
          _connectionStarted = false;
          _connectedEpName = "";
        });
      } catch (e) {
        logger.e('Error disconnecting: $e');
      }
    }

    void sendData(String data) async {
      try {
        await advertiserViewModel.sendData(data);
        await discovererViewModel.sendData(data);
      } catch (e) {
        logger.e('Error sending data: $e');
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: const NCAppBar(),
        drawer: const NCDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Declare device name...',
              ),
              controller: _deviceName, // Add this line
            ),
            if (discovererViewModel.getDiscoveredDevices().isEmpty)
              Text('Running on: ${advertiserViewModel.getPlatformVersion()}\n'),
            if (discovererViewModel.getDiscoveredDevices().isNotEmpty &&
                !_connectionStarted)
              discoveredDevices(discovererViewModel),
            if (_connectionStarted)
              Text("Successfully connected to $_connectedEpName"),
            if (_message.isNotEmpty) Text('Message: $_message'),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Type something...',
              ),
              controller: _textFieldController, // Add this line
            ),
            ElevatedButton(
              onPressed: () {
                String inputData = _textFieldController.text;
                sendData(inputData);
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
                onPressed: advertise,
                child: const Text('Advertise'),
              ),
              ElevatedButton(
                onPressed: disconnect,
                child: const Text('Disconnect'),
              ),
              ElevatedButton(
                onPressed: startDiscovery,
                child: const Text('Discovery'),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget discoveredDevices(DiscovererViewModel discovererViewModel) {
    Future<void> Function() connect(String epId, String epName) {
      return () async {
        setState(() {
          _connectionStarted = true;
          _connectedEpName = epName;
        });

        await discovererViewModel.connect(epId);
      };
    }

    return SizedBox(
        height: 200,
        child: Consumer<DiscovererViewModel>(
            builder: (context, value, child) => ListView.separated(
                  itemCount: discovererViewModel.getDiscoveredDevices().length,
                  itemBuilder: (context, index) {
                    var device =
                        discovererViewModel.getDiscoveredDevices()[index];
                    return ElevatedButton(
                        onPressed:
                            connect(device.endpointId, device.endpointName),
                        child: Text('Connect ${device.endpointName}'));
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                )));
  }
}
