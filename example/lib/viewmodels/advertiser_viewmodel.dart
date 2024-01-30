import 'package:flutter/material.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/advertiser_model.dart';

class AdvertiserViewModel with ChangeNotifier {
  late Advertiser advertiser;

  late ConnectionsManager connectionsManager;
  String? _username;
  bool _isConnected = false;
  Device? _connectedDevice;

  AdvertiserViewModel() {
    advertiser = Advertiser();
    _username = advertiser.username;

    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackConnectionInitiated(_commonCallback);
    connectionsManager
        .setCallbackSuccessfulConnection(_callbackSuccessfulConnection);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackSuccessfulConnection(Device device) {
    _connectedDevice = device;
    _isConnected = true;
    _commonCallback(device);
  }

  void setUsername(String username, [bool notify = true]) {
    _username = username;
    if (notify) {
      notifyListeners();
    }
  }

  String getUsername() {
    return _username ?? advertiser.username ?? "";
  }

  bool get isConnected => _isConnected;
  bool get isAdvertising => advertiser.isAdvertising;

  Future<void> startAdvertising() async {
    await advertiser.requestPermissions();
    await advertiser.advertise(_username);
    notifyListeners();
  }

  Future<void> disconnect() async {
    return advertiser.disconnect();
  }

  Future<void> stopAdvertising() async {
    await advertiser.stopAdvertising();
    notifyListeners();
  }

  Future<void> connect(String endpointId) {
    return advertiser.connect(endpointId);
  }

  Future<void> sendData(String message) async {
    if (_connectedDevice != null) {
      connectionsManager.sendMessageToDevice(
          _connectedDevice!.endpointId, message);
    }
  }

  String? getConnectedDeviceName() {
    if (_connectedDevice != null) {
      return _connectedDevice!.endpointName;
    }

    return null;
  }

  Device? getConnectedDevice() {
    return _connectedDevice;
  }
}
