import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nearby_cross/nearby_cross.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDiscovering = false;
  String _platformVersion = 'Unknown';
  String _endpointId = 'Unknown 2';
  Color _bgColor = Colors.white;
  final _nearbyCrossPlugin = NearbyCross();

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
          var color = call.arguments;
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
        appBar: AppBar(
          title: const Text('Plugin example app'),
          backgroundColor: _bgColor,
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n found: $_endpointId'),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 16.0,
              left: 16,
              child: FloatingActionButton(
                onPressed: _advertise,
                child: const Icon(Icons.menu),
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16,
              child: FloatingActionButton(
                onPressed: _startDiscovery,
                child: const Icon(Icons.color_lens),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGenerateColorPressed() async {
    final randomColor = await NearbyCross.generateColor();
    setState(() {
      _bgColor = randomColor;
    });
  }

  void _startDiscovery() async {
    setState(() {
      _isDiscovering = true;
    });

    try {
      await NearbyCross.requestPermissions();
      await NearbyCross.startDiscovery(
          'com.google.location.nearby.apps.helloconnections');
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

    try {
      await NearbyCross.requestPermissions();
      await NearbyCross.advertise(
          'com.google.location.nearby.apps.helloconnections');
    } catch (e) {
      print('Error starting discovery: $e');
    }

    setState(() {
      _isDiscovering = false;
    });
  }
}
