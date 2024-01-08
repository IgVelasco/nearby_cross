import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/nearby_cross.dart';

typedef Item = HashMap<String, String>;

class AppModel extends ChangeNotifier {
  // Create logger
  var logger = Logger();
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      _platformVersion = await _nearbyCrossPlugin.getPlatformVersion() ??
          'Unknown platform version';
      logger.i("Running on  $_platformVersion");
      _nearbyCrossPlugin.methodChannel.setMethodCallHandler((call) async {
        if (call.method == 'onEndpointFound') {
          var arguments = call.arguments as Map<Object?, Object?>;
          logger.i("Found Device $arguments");

          add(Item.from({
            "endpointId": arguments["endpointId"] as String,
            "endpointName": arguments["endpointName"] as String
          }));
          logger.i("List of devices $devicesFound");
        } else if (call.method == 'payloadReceived') {
          var arguments = call.arguments as Map<Object?, Object?>;
          logger.i("Received Payload $arguments");
          messageReceived = arguments["message"] as String;
          notifyListeners();
        }
      });
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
      notifyListeners();
    } on Exception catch (e) {
      logger.e("Exception $e");
    }
  }

  String _platformVersion = "";
  String messageReceived = "";
  bool _isDiscovering = false;
  bool _isAdvertising = false;
  bool _isAdvertiser = false;
  bool _connected = false;
  final _nearbyCrossPlugin = NearbyCross();
  String serviceId = 'com.example.nearbyCrossExample';
  List<Item> devicesFound = [];

  String _username = 'default username';
  Item _connectedAdvertiser = HashMap();

  final List<Item> advertisers = [
    HashMap.from({"username": "Ric", "endpointId": "aX09"}),
    HashMap.from({"username": "NICS", "endpointId": "B2FF"}),
  ];

  bool get isDiscovering => _isDiscovering;
  bool get isAdvertiser => _isAdvertiser;
  bool get connected => _connected;
  Item get connectedAdvertiser => _connectedAdvertiser;
  String get username => _username;
  String get advertiserMode => _isAdvertiser ? "Advertiser" : "Discoverer";
  String get platformVersion => _platformVersion;

  UnmodifiableListView<Item> get items => UnmodifiableListView(devicesFound);

  int get totalAmount => devicesFound.length;

  void add(Item item) {
    devicesFound.add(item);
    notifyListeners();
  }

  void removeAll() {
    devicesFound.clear();
    notifyListeners();
  }

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void toggleAdvertiserMode() {
    _isAdvertiser = !_isAdvertiser;
    notifyListeners();
  }

  void connectToAdvertiser(Item item) async {
    var epId = item["endpointId"] ?? "";
    logger.i("Connecting to advertiser $epId name ${item["endpointName"]}");
    _connectedAdvertiser = item;
    _connected = true;
    await _nearbyCrossPlugin.connect(epId);

    // _username = newUsername;
    notifyListeners();
  }

  void disconnect() async {
    try {
      await _nearbyCrossPlugin.disconnect(serviceId);
      // Navigator.pop(context);
    } catch (e) {
      logger.e('Error disconnecting: $e');
    }
    _connectedAdvertiser = HashMap();
    _connected = false;
    logger.i("Disconnected!");
    notifyListeners();
  }

  void toggleAdvertising() async {
    if (_isAdvertising) {
      _isAdvertising = false;
    } else {
      _isAdvertising = true;
      try {
        await NearbyCross.requestPermissions();
        await _nearbyCrossPlugin.advertise(serviceId, username);
      } catch (e) {
        logger.e('Error starting advertising: $e');
      }
    }
  }

  void startDiscovery() async {
    _isDiscovering = true;

    var deviceName = username;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.startDiscovery(serviceId, deviceName);
    } catch (e) {
      logger.e('Error starting discovery: $e');
    }

    logger.i("Starting discovery!");
    notifyListeners();
  }

  void sendData(data) async {
    logger.i("Sending data $data");
    await _nearbyCrossPlugin.sendData(data);
  }

  void stopDiscovery() {
    _isDiscovering = false;
    logger.i("Stopping discovery!");
    notifyListeners();
  }
}
