import 'package:flutter/material.dart';
import 'package:nearby_cross/models/advertiser_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';

class MainViewModel with ChangeNotifier {
  late Discoverer discoverer;
  late Advertiser advertiser;

  Set<Device> connectedDevices = {};
  Device? lastMessageDevice;

  MainViewModel() {
    discoverer = Discoverer();
    discoverer.setOnDeviceFoundCallback(_commonCallback);
    discoverer.setCallbackConnectionInitiated(_commonCallback);
    discoverer.setCallbackSuccessfulConnection(_callbackSuccessfulConnection);
    discoverer.setCallbackReceivedMessage(_callbackReceivedMessage);

    advertiser = Advertiser();
    advertiser.setCallbackConnectionInitiated(_commonCallback);
    advertiser.setCallbackSuccessfulConnection(_callbackSuccessfulConnection);
    advertiser.setCallbackReceivedMessage(_callbackReceivedMessage);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackSuccessfulConnection(Device device) {
    connectedDevices.add(device);
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    lastMessageDevice = device;
    notifyListeners();
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
    for (var device in connectedDevices) {
      device.sendMessage(message);
    }
  }

  String? getLastMessageReceived() {
    if (lastMessageDevice == null) {
      return null;
    }

    return lastMessageDevice!.getLastMessage();
  }
}
