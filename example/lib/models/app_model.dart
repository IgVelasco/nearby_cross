import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nearby_cross/nearby_cross.dart';

typedef Item = HashMap<String, String>;

class AppModel extends ChangeNotifier {
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      _platformVersion = await _nearbyCrossPlugin.getPlatformVersion() ??
          'Unknown platform version';
      print("Running on  $_platformVersion");
      _nearbyCrossPlugin.methodChannel.setMethodCallHandler((call) async {
        if (call.method == 'onEndpointFound') {
          var arguments = call.arguments as Map<Object?, Object?>;
          print("Found Device $arguments");

          add(Item.from({
            "endpointId": arguments["endpointId"] as String,
            "endpointName": arguments["endpointName"] as String
          }));
          print("List of devices $devicesFound");
        } else if (call.method == 'payloadReceived') {
          var arguments = call.arguments as Map<Object?, Object?>;
          print("Received Payload $arguments");
          messageReceived = arguments["message"] as String;
          notifyListeners();
        }
      });
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
      notifyListeners();
    } on Exception catch (e) {
      print("Exception $e");
    }
  }

  String _platformVersion = "";
  String messageReceived = "";
  bool _isDiscovering = false;
  bool _connected = false;
  final _nearbyCrossPlugin = NearbyCross();
  String serviceId = 'com.example.nearbyCrossExample';
  List<Item> devicesFound = [];

  String _username = 'default username';
  Item _connectedAdvertiser = HashMap();

  final List<Item> _advertisers = [
    HashMap.from({"username": "Ric", "endpointId": "aX09"}),
    HashMap.from({"username": "NICS", "endpointId": "B2FF"}),
  ];

  bool get isDiscovering => _isDiscovering;
  bool get connected => _connected;
  Item get connectedAdvertiser => _connectedAdvertiser;
  String get username => _username;
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

  void connectToAdvertiser(Item item) async {
    var epId = item["endpointId"] ?? "";
    print("Connecting to advertiser $epId name ${item["endpointName"]}");
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
      print('Error disconnecting: $e');
    }
    _connectedAdvertiser = HashMap();
    _connected = false;
    print("Disconnected!");
    notifyListeners();
  }

  void startDiscovery() async {
    _isDiscovering = true;

    var deviceName = username;

    try {
      await NearbyCross.requestPermissions();
      await _nearbyCrossPlugin.startDiscovery(serviceId, deviceName);
    } catch (e) {
      print('Error starting discovery: $e');
    }

    print("Starting discovery!");
    notifyListeners();
  }

  void sendData(data) async {
    print("sending data $data");
    await _nearbyCrossPlugin.sendData(data);
  }

  void stopDiscovery() {
    _isDiscovering = false;
    print("Stopping discovery!");
    notifyListeners();
  }
}
