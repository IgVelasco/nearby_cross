import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross/helpers/platform_utils.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/advertiser_model.dart';

class AdvertiserViewModel with ChangeNotifier {
  late Advertiser advertiser;

  late ConnectionsManager connectionsManager;
  bool _manualAcceptConnections = false;
  Device? _connectedDevice;
  Uint8List rawDeviceInfo = Uint8List(0);

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

  void setDeviceInfo(Uint8List deviceInfo, [bool notify = true]) {
    if (deviceInfo.isEmpty) return;
    rawDeviceInfo = deviceInfo;
    BytesBuilder bb = BytesBuilder();
    bb.add(deviceInfo);

    var signingManger = connectionsManager.getSigningManager();
    if (signingManger != null) {
      var deviceInfoSign = signingManger.getSignatureBytes(deviceInfo);

      bb.add(utf8.encode("&"));
      bb.add(deviceInfoSign);
    }

    advertiser.deviceInfo = bb.toBytes();
    if (notify) {
      notifyListeners();
    }
  }

  Uint8List? getDeviceInfo() {
    return rawDeviceInfo;
  }

  bool get isConnected => advertiser.isConnected;
  bool get isAdvertising => advertiser.isAdvertising;

  bool get manualAcceptConnections => _manualAcceptConnections;

  Future<void> startAdvertising(NearbyStrategies strategy) async {
    await advertiser
        .requestPermissions(); // TODO: move this to the constructor of the plugin

    if (advertiser.deviceInfo.isEmpty) {
      var deviceName = utf8.encode((await getDeviceName()));
      setDeviceInfo(deviceName, false);
    }

    await advertiser.advertise(
      manualAcceptConnections: _manualAcceptConnections,
      strategy: strategy,
    );
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

  Uint8List? getConnectedDeviceName() {
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
