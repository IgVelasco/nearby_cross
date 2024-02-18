import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/advertiser_model.dart';

class AdvertiserViewModel with ChangeNotifier {
  late Advertiser advertiser;

  late ConnectionsManager connectionsManager;
  String? _username;
  bool _manualAcceptConnections = false;
  Device? _connectedDevice;

  AdvertiserViewModel() {
    advertiser = Advertiser();
    _username = advertiser.username;

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
    _commonCallback(device);
  }

  void _callbackSuccessfulConnection(Device device) {
    _connectedDevice = device;
    advertiser.isConnected = true;
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

  bool get isConnected => advertiser.isConnected;
  bool get isAdvertising => advertiser.isAdvertising;
  bool get isRunning => advertiser.isRunning;

  bool get manualAcceptConnections => _manualAcceptConnections;

  Future<void> startAdvertising() async {
    await advertiser
        .requestPermissions(); // TODO: move this to the constructor of the plugin
    await advertiser.advertise(_username,
        manualAcceptConnections: _manualAcceptConnections);
    notifyListeners();
  }

  Future<void> stopAdvertising() async {
    await advertiser.stopAdvertising();
    notifyListeners();
  }

  Future<void> stopAllConnections() async {
    await advertiser.stopAllConnections();
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

  void toggleManualAcceptConnections() {
    _manualAcceptConnections = !_manualAcceptConnections;
    notifyListeners();
  }

  int getPendingConnectionsCount() {
    return connectionsManager.pendingAcceptConnections.length;
  }
}
