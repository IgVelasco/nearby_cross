import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:nearby_cross_example/viewmodels/main_viewmodel.dart';
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
      ChangeNotifierProvider(create: (context) => MainViewModel()),
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
  String? _message;

  bool _connectionStarted = false;
  String _connectedEpName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);

    if (mainViewModel.getPlatformVersion() == null) {
      mainViewModel.findPlatformVersion();
    }

    _message = mainViewModel.getLastMessageReceived();

    void startDiscovery() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await mainViewModel.startDiscovering(deviceName);
      } catch (e) {
        logger.e('Error starting discovery: $e');
      }
    }

    void advertise() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await mainViewModel.startAdvertising(deviceName);
      } catch (e) {
        logger.e('Error starting advertising: $e');
      }
    }

    void disconnect() async {
      try {
        await mainViewModel.disconnect();
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
        mainViewModel.sendData(data);
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
            if (mainViewModel.getDiscoveredDevices().isEmpty)
              Text('Running on: ${mainViewModel.getPlatformVersion()}\n'),
            if (mainViewModel.getDiscoveredDevices().isNotEmpty &&
                !_connectionStarted)
              discoveredDevices(mainViewModel),
            if (_connectionStarted)
              Text("Successfully connected to $_connectedEpName"),
            if (_message != null) Text('Message: $_message'),
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

  Widget discoveredDevices(MainViewModel mainViewModel) {
    Future<void> Function() connect(String epId, String epName) {
      return () async {
        setState(() {
          _connectionStarted = true;
          _connectedEpName = epName;
        });

        await mainViewModel.connect(epId);
      };
    }

    return SizedBox(
        height: 200,
        child: Consumer<MainViewModel>(
            builder: (context, value, child) => ListView.separated(
                  itemCount: mainViewModel.getDiscoveredDevices().length,
                  itemBuilder: (context, index) {
                    var device = mainViewModel.getDiscoveredDevices()[index];
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
