import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross_example/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'models/app_model.dart';


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
  final String _platformVersion = 'Unknown';
  String _message = '';
  final _nearbyCrossPlugin = NearbyCross();
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
    void startDiscovery() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await NearbyCross.requestPermissions();
        await _nearbyCrossPlugin.startDiscovery(serviceId, deviceName);
      } catch (e) {
        logger.e('Error starting discovery: $e');
      }
    }

    void advertise() async {
      var deviceName = _deviceName.text.isNotEmpty ? _deviceName.text : null;

      try {
        await NearbyCross.requestPermissions();
        await _nearbyCrossPlugin.advertise(serviceId, deviceName);
      } catch (e) {
        logger.e('Error starting advertising: $e');
      }
    }

    void disconnect() async {
      try {
        await _nearbyCrossPlugin.disconnect(serviceId);
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
        await _nearbyCrossPlugin.sendData(data);
      } catch (e) {
        logger.e('Error sending data: $e');
      }
    }

    return const MaterialApp(home: MainScreen());
  }
}
