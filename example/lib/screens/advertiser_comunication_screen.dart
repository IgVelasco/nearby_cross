import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:provider/provider.dart';
import '../widgets/nc_appBar.dart';
import '../widgets/nc_drawer.dart';
import '../models/app_model.dart';

class AdvertiserComunicationScreen extends StatefulWidget {
  final Item advertiser;
  const AdvertiserComunicationScreen(this.advertiser, {super.key});

  @override
  State<AdvertiserComunicationScreen> createState() =>
      _AdvertiserComunicationScreenState();
}

class _AdvertiserComunicationScreenState
    extends State<AdvertiserComunicationScreen> {
  final TextEditingController _textFieldController = TextEditingController();
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                onPressed: _disconnect,
                child: const Text('Disconnect'),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _startDiscovery() async {
    var appModel = AppModel();

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.startDiscovery(serviceId, appModel.username);
    } catch (e) {
      print('Error starting discovery: $e');
    }
  }

  void _advertise() async {
    var appModel = AppModel();
    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.advertise(serviceId, appModel.username);
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
      Navigator.pop(context);
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
