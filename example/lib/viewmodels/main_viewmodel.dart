import 'package:flutter/material.dart';
import 'package:nearby_cross/models/advertiser_model.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';

class MainViewModel with ChangeNotifier {
  late Discoverer discoverer;
  late Advertiser advertiser;
  late ConnectionsManager connectionsManager;
  Device? lastMessageDevice;

  MainViewModel() {
    discoverer = Discoverer();
    discoverer.setOnDeviceFoundCallback(_commonCallback);

    advertiser = Advertiser();

    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackConnectionInitiated(_commonCallback);
    connectionsManager.setCallbackSuccessfulConnection(_commonCallback);
    connectionsManager.setCallbackReceivedMessage(_callbackReceivedMessage);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    lastMessageDevice = device;
    _commonCallback(device);
  }

  void findPlatformVersion() {
    // Can also be the discoverer
    advertiser.getPlatformVersion().then((_) {
      notifyListeners();
    });
  }

  String? getPlatformVersion() {
    // Can also be the discoverer
    return advertiser.platformVersion;
  }

  Future<void> startDiscovering(String? deviceName) async {
    await discoverer.requestPermissions();
    await discoverer.startDiscovery(deviceName);
  }

  Future<void> startAdvertising(String? deviceName) async {
    await advertiser.requestPermissions();
    await advertiser.advertise(deviceName);
  }

  List<Device> getDiscoveredDevices() {
    return discoverer.listOfDiscoveredDevices.toList();
  }

  Future<void> connect(String endpointId) {
    return discoverer.connect(endpointId);
  }

  Future<void> disconnect() async {
    await advertiser.disconnect();
  }

  Future<void> sendData(String message) async {
    connectionsManager.broadcastMessage(message);
  }

  String? getLastMessageReceived() {
    if (lastMessageDevice == null) {
      return null;
    }

    return lastMessageDevice!.getLastMessage();
  }
}
