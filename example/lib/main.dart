import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/advertiser_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';
import 'package:provider/provider.dart';
import 'models/app_model.dart';
import 'widgets/nc_drawer.dart';

import 'widgets/nc_app_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        var appModel = AppModel();
        appModel.initPlatformState();
        return appModel;
      },
      child: const MyApp(),
    ),
  );
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
  String? _platformVersion = 'Unknown';
  String _message = '';
  final _discoverer = Discoverer();
  final _advertiser = Advertiser();
  List<Map<String, String>> devicesFound = [];

  bool _connectionStarted = false;
  String _connectedEpName = "";

  String serviceId = 'com.example.nearbyCrossExample';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _discoverer.getPlatformVersion().then((value) => setState(() {
          _platformVersion = value;
        }));

    void startDiscovery() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await _discoverer.requestPermissions(); // Can also be advertiser
        await _discoverer.startDiscovery(serviceId, deviceName);
      } catch (e) {
        logger.e('Error starting discovery: $e');
      }
    }

    void advertise() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await _advertiser.requestPermissions(); // Can also be discoverer
        await _advertiser.advertise(serviceId, deviceName);
      } catch (e) {
        logger.e('Error starting advertising: $e');
      }
    }

    void disconnect() async {
      try {
        // TODO: Disconect should validate if Device exists first
        await _advertiser.disconnect(serviceId);
        setState(() {
          _message = "";
          devicesFound = [];
          _connectionStarted = false;
          _connectedEpName = "";
        });
      } catch (e) {
        logger.e('Error disconnecting: $e');
      }
    }

    void sendData(String data) async {
      try {
        await _advertiser.sendData(data);
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
            if (devicesFound.isEmpty) Text('Running on: $_platformVersion\n'),
            if (devicesFound.isNotEmpty && !_connectionStarted)
              discoveredDevices(),
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

  Widget discoveredDevices() {
    Future<void> Function() connect(String epId, String epName) {
      return () async {
        setState(() {
          _connectionStarted = true;
          _connectedEpName = epName;
        });

        await _discoverer.connect(epId);
      };
    }

    return SizedBox(
        height: 200,
        child: ListView.separated(
          itemCount: devicesFound.length,
          itemBuilder: (context, index) {
            var device = devicesFound[index];
            return ElevatedButton(
                onPressed: connect(device["endpointId"] as String,
                    device["endpointName"] as String),
                child: Text('Connect ${device["endpointName"]}'));
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ));
  }
}
