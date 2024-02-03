import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';

class DiscovererViewModel with ChangeNotifier {
  late Discoverer discoverer;

  late ConnectionsManager connectionsManager;
  String? _username;
  bool _isConnected = false;
  Device? _connectedDevice;

  DiscovererViewModel() {
    discoverer = Discoverer();
    discoverer.setOnDeviceFoundCallback(_commonCallback);
    _username = discoverer.username;

    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackPendingAcceptConnection(
        _setCallbackPendingAcceptConnection);
    connectionsManager.setCallbackConnectionInitiated(_commonCallback);
    connectionsManager
        .setCallbackSuccessfulConnection(_callbackSuccessfulConnection);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _setCallbackPendingAcceptConnection(Device device) {
    Logger().i("Device ${device.endpointName} wants to connect");
  }

  void _callbackSuccessfulConnection(Device device) {
    _connectedDevice = device;
    _isConnected = true;
    _commonCallback(device);
  }

  bool get isConnected => _isConnected;

  bool get isDiscovering => discoverer.isDiscovering;

  String getUsername() {
    return _username ?? discoverer.username ?? "";
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

  bool canStartDiscovererFlow() {
    return _username != null;
  }

  Future<void> startDiscovering() async {
    await discoverer.requestPermissions();
    await discoverer.startDiscovery(_username);
    notifyListeners();
  }

  Future<void> disconnect() async {
    return discoverer.disconnect();
  }

  Future<void> stopDiscovery() async {
    await discoverer.stopDiscovery();
    notifyListeners();
  }

  Future<void> connect(String endpointId) {
    return discoverer.connect(endpointId);
  }

  Future<void> sendData(String message) async {
    if (_connectedDevice != null) {
      connectionsManager.sendMessageToDevice(
          _connectedDevice!.endpointId, message);
    }
  }

  void setUsername(String username, [bool notify = true]) {
    _username = username;
    if (notify) {
      notifyListeners();
    }
  }

  String? getConnectedDeviceName() {
    if (_connectedDevice != null) {
      return _connectedDevice!.endpointName;
    }

    return null;
  }

  HashMap<String, String> getItem() {
    final connectedDevice = _connectedDevice;
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

  Device? getConnectedDevice() {
    return _connectedDevice;
  }
}
