import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/advertiser_model.dart';

class AdvertiserViewModel with ChangeNotifier {
  late Advertiser advertiser;

  late ConnectionsManager connectionsManager;
  bool _manualAcceptConnections = false;
  Device? _connectedDevice;

  AdvertiserViewModel() {
    advertiser = Advertiser();

    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackPendingAcceptConnection(
        "AdvertiserViewModel:pendingAcceptConnection",
        _setCallbackPendingAcceptConnection);
    connectionsManager.setCallbackConnectionInitiated(
        "AdvertiserViewModel:connetionInitiated", _commonCallback);
    connectionsManager.setCallbackSuccessfulConnection(
        "AdvertiserViewModel:successfulConnection",
        _callbackSuccessfulConnection);
  }

  @override
  void dispose() {
    connectionsManager
        .removeNamedCallback("AdvertiserViewModel:pendingAcceptConnection");
    connectionsManager
        .removeNamedCallback("AdvertiserViewModel:connetionInitiated");
    connectionsManager
        .removeNamedCallback("AdvertiserViewModel:successfulConnection");
    super.dispose();
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
    _commonCallback(device);
  }

  void setUsername(String? username, [bool notify = true]) {
    if (username == null) return;
    advertiser.username = username;
    if (notify) {
      notifyListeners();
    }
  }

  String? getUsername() {
    return advertiser.username;
  }

  bool get isConnected => advertiser.isConnected;
  bool get isAdvertising => advertiser.isAdvertising;

  bool get manualAcceptConnections => _manualAcceptConnections;

  Future<void> startAdvertising(NearbyStrategies strategy) async {
    await advertiser
        .requestPermissions(); // TODO: move this to the constructor of the plugin
    await advertiser.advertise(
        manualAcceptConnections: _manualAcceptConnections, strategy: strategy);
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
