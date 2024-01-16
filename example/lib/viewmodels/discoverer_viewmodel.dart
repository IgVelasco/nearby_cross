import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';

class DiscovererViewModel with ChangeNotifier {
  late Discoverer discoverer;

  late ConnectionsManager connectionsManager;
  Device? lastMessageDevice;
  String username = "default username";
  bool isDiscovering = false;
  bool isConnected = false;
  Device? connectedDevice;

  DiscovererViewModel() {
    print("Creating view Model");
    discoverer = Discoverer();
    discoverer.setOnDeviceFoundCallback(_commonCallback);

    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackConnectionInitiated(_commonCallback);
    connectionsManager
        .setCallbackSuccessfulConnection(_callbackSuccessfulConnection);
    connectionsManager.setCallbackReceivedMessage(_callbackReceivedMessage);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackSuccessfulConnection(Device device) {
    connectedDevice = device;
    isConnected = true;
    _commonCallback(device);
  }

  void _callbackReceivedMessage(Device device) {
    lastMessageDevice = device;
    _commonCallback(device);
  }

  String? getPlatformVersion() {
    return discoverer.platformVersion;
  }

  void findPlatformVersion() {
    // Can also be the discoverer
    discoverer.getPlatformVersion().then((_) {
      notifyListeners();
    });
  }

  Future<void> startDiscovering() async {
    await discoverer.requestPermissions();
    await discoverer.startDiscovery(username);
    isDiscovering = true;
  }

  Future<void> disconnect() async {
    return discoverer.disconnect();
  }

  Future<void> stopDiscovery() async {
    await discoverer.disconnect();
    isDiscovering = false;
    notifyListeners();
  }

  Future<void> connect(String endpointId) {
    return discoverer.connect(endpointId);
  }

  Future<void> sendData(String message) async {
    if (connectedDevice != null) {
      connectionsManager.sendMessageToDevice(
          connectedDevice!.endpointId, message);
    }
  }

  String? getLastMessageReceived() {
    if (lastMessageDevice == null) {
      return null;
    }

    return lastMessageDevice!.getLastMessage();
  }

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  String? getConnectedDeviceName() {
    if (connectedDevice != null) {
      return connectedDevice!.endpointName;
    }

    return null;
  }

  HashMap<String, String> getItem() {
    final connectedDevice = this.connectedDevice;
    if (connectedDevice != null) {
      var hm = HashMap<String, String>.from(
          {connectedDevice.endpointId: connectedDevice.endpointName});
      return hm;
    }

    return HashMap<String, String>.from({});
  }

  List<Device> getDiscoveredDevices() {
    return discoverer.listOfDiscoveredDevices.toList();
  }

  int getDiscoveredDevicesAmount() {
    return discoverer.getNumberOfDiscoveredDevices();
  }
}
