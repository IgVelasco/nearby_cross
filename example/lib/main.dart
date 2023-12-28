import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var logger = Logger();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _advertiserName = TextEditingController();
  String _platformVersion = 'Unknown';
  String _endpointId = 'Unknown 2';
  final Color _bgColor = Colors.white;
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
          logger.i('Endpoint found: $_endpointId');
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
        appBar: AppBar(
          title: const Text('Plugin example app'),
          backgroundColor: _bgColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Declare advertiser name...',
              ),
              controller: _advertiserName, // Add this line
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
    setState(() {});

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.startDiscovery(serviceId);
    } catch (e) {
      logger.i('Error starting discovery: $e');
    }

    setState(() {});
  }

  void _advertise() async {
    setState(() {});

    var advName = _advertiserName.text.isNotEmpty ? _advertiserName.text : null;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.advertise(serviceId, advName);
    } catch (e) {
      logger.i('Error starting advertising: $e');
    }

    setState(() {});
  }

  void _disconnect() async {
    try {
      await _nearbyCrossPlugin.disconnect(serviceId);
    } catch (e) {
      logger.i('Error disconnecting: $e');
    }
  }

  void sendData(String data) async {
    try {
      await _nearbyCrossPlugin.sendData(data);
    } catch (e) {
      logger.i('Error disconnecting: $e');
    }
  }
}
