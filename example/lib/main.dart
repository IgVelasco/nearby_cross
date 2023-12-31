import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:provider/provider.dart';
import 'models/app_model.dart';
import 'widgets/nc_drawer.dart';

import 'widgets/nc_appBar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppModel(),
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
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _deviceName = TextEditingController();
  bool _isDiscovering = false;
  String _platformVersion = 'Unknown';
  String _endpointId = 'Unknown 2';
  Color _bgColor = Colors.white;
  final _nearbyCrossPlugin = NearbyCross();

  String serviceId = 'com.example.nearbyCrossExample';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _nearbyCrossPlugin.getPlatformVersion() ??
          'Unknown platform version';

      _nearbyCrossPlugin.methodChannel.setMethodCallHandler((call) async {
        if (call.method == 'onEndpointFound') {
          setState(() {
            _endpointId = call.arguments;
          });
          print('Endpoint found: $_endpointId');
        }
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Text('Running on: $_platformVersion\n found: $_endpointId'),
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
                onPressed: _advertise,
                child: const Text('Advertise'),
              ),
              ElevatedButton(
                onPressed: _disconnect,
                child: const Text('Disconnect'),
              ),
              ElevatedButton(
                onPressed: _startDiscovery,
                child: const Text('Discovery'),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _startDiscovery() async {
    setState(() {
      _isDiscovering = true;
    });

    var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.startDiscovery(serviceId, deviceName);
    } catch (e) {
      print('Error starting discovery: $e');
    }

    setState(() {
      _isDiscovering = false;
    });
  }

  void _advertise() async {
    setState(() {
      _isDiscovering = true;
    });

    var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.advertise(serviceId, deviceName);
    } catch (e) {
      print('Error starting advertising: $e');
    }

    setState(() {
      _isDiscovering = false;
    });
  }

  void _disconnect() async {
    try {
      await _nearbyCrossPlugin.disconnect(serviceId);
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }

  void sendData(String data) async {
    try {
      await _nearbyCrossPlugin.sendData(data);
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }
}
