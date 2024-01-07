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
  final TextEditingController _deviceName = TextEditingController();
  String _platformVersion = 'Unknown';
  String _message = '';
  final Color _bgColor = Colors.white;
  final _nearbyCrossPlugin = NearbyCross();
  List<Map<String, String>> devicesFound = [];

  bool _connectionStarted = false;
  String _connectedEpName = "";

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
          var arguments = call.arguments as Map<Object?, Object?>;
          setState(() {
            devicesFound.add({
              "endpointId": arguments["endpointId"] as String,
              "endpointName": arguments["endpointName"] as String
            });
          });
        } else if (call.method == 'payloadReceived') {
          var arguments = call.arguments as Map<Object?, Object?>;
          setState(() {
            _message = arguments["message"] as String;
          });
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
                broadcastData(inputData);
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

  Widget discoveredDevices() {
    return SizedBox(
        height: 200,
        child: ListView.separated(
          itemCount: devicesFound.length,
          itemBuilder: (context, index) {
            var device = devicesFound[index];
            return ElevatedButton(
                onPressed: _connect(device["endpointId"] as String,
                    device["endpointName"] as String),
                child: Text('Connect ${device["endpointName"]}'));
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ));
  }

  Future<void> Function() _connect(String epId, String epName) {
    return () async {
      setState(() {
        _connectionStarted = true;
        _connectedEpName = epName;
      });

      await _nearbyCrossPlugin.connect(epId);
    };
  }

  void _startDiscovery() async {
    var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.startDiscovery(serviceId, deviceName);
    } catch (e) {
      logger.i('Error starting discovery: $e');
    }
  }

  void _advertise() async {
    var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.advertise(serviceId, deviceName);
    } catch (e) {
      logger.i('Error starting advertising: $e');
    }
  }

  void _disconnect() async {
    try {
      await _nearbyCrossPlugin.disconnect(serviceId);
      setState(() {
        _message = "";
        devicesFound = [];
        _connectionStarted = false;
        _connectedEpName = "";
      });
    } catch (e) {
      logger.i('Error disconnecting: $e');
    }
  }

  void broadcastData(String data) async {
    try {
      await _nearbyCrossPlugin.broadcastData(data);
    } catch (e) {
      logger.i('Error disconnecting: $e');
    }
  }
}
