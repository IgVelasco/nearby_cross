import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross/helpers/platform_utils.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';
import 'package:nearby_cross_example/constants/app.constants.dart';

class DiscovererViewModel with ChangeNotifier {
  late Discoverer discoverer;

  late ConnectionsManager connectionsManager;
  Device? _connectedDevice;
  Uint8List rawDeviceInfo = Uint8List(0);

  DiscovererViewModel() {
    discoverer = Discoverer();
    discoverer.setOnDeviceFoundCallback(_commonCallback);

    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackPendingAcceptConnection(
        "DiscovererViewModel:pendingAcceptConnection",
        _callbackPendingAcceptConnection);
    connectionsManager.setCallbackConnectionInitiated(
        "DiscovererViewModel:connectionInitiated", _commonCallback);
    connectionsManager.setCallbackSuccessfulConnection(
        "DiscovererViewModel:successfulConnection",
        _callbackSuccessfulConnection);
  }

  @override
  void dispose() {
    connectionsManager
        .removeNamedCallback("DiscovererViewModel:pendingAcceptConnection");
    connectionsManager
        .removeNamedCallback("DiscovererViewModel:connectionInitiated");
    connectionsManager
        .removeNamedCallback("DiscovererViewModel:successfulConnection");
    super.dispose();
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackPendingAcceptConnection(Device device) {
    Logger().i("Device ${device.endpointName} wants to connect");
    _commonCallback(device);
  }

  void _callbackSuccessfulConnection(Device device) {
    _connectedDevice = device;
    _commonCallback(device);
  }

  bool get isConnected => discoverer.isConnected;

  bool get isDiscovering => discoverer.isDiscovering;

  bool get isRunning => discoverer.isConnected || discoverer.isDiscovering;

  Uint8List? getDeviceInfo() {
    return rawDeviceInfo;
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
    var deviceInfo = getDeviceInfo();
    return deviceInfo != null && deviceInfo.isNotEmpty;
  }

  Future<void> startDiscovering(NearbyStrategies strategy) async {
    await discoverer
        .requestPermissions(); // TODO: move this to the constructor of the plugin

    if (discoverer.deviceInfo.isEmpty) {
      var deviceName = utf8.encode((await getDeviceName()));
      setDeviceInfo(deviceName, false);
    }

    await discoverer.startDiscovery(AppConstants.serviceId, strategy: strategy);
    notifyListeners();
  }

  Future<void> disconnectFrom(String endpointId) async {
    return discoverer.disconnectFrom(endpointId);
  }

  Future<void> stopDiscovering() async {
    await discoverer.stopDiscovering();
    notifyListeners();
  }

  Future<void> connect(String endpointId) {
    return discoverer.connect(endpointId);
  }

  Future<void> sendData(String message) async {
    final deviceConnected = getConnectedDevice();
    if (deviceConnected != null) {
      connectionsManager.sendMessageToDevice(
          deviceConnected.endpointId, message);
    }
  }

  void setDeviceInfo(Uint8List? deviceInfo, [bool notify = true]) {
    if (deviceInfo == null || deviceInfo.isEmpty) return;
    rawDeviceInfo = deviceInfo;
    BytesBuilder bb = BytesBuilder();
    bb.add(deviceInfo);

    var signingManger = connectionsManager.getSigningManager();
    if (signingManger != null) {
      var deviceInfoSign = signingManger.getSignatureBytes(deviceInfo);

      bb.add(AppConstants.separator);
      bb.add(deviceInfoSign);
    }

    discoverer.deviceInfo = bb.toBytes();
    if (notify) {
      notifyListeners();
    }
  }

  Uint8List? getConnectedDeviceName() {
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

  Future<void> stopAllConnections() async {
    await discoverer.stopAllConnections();
    notifyListeners();
  }

  String getEndpointNameFromDevice(Device device) {
    var fullDeviceInfo = device.endpointName;
    var indexSeparator = fullDeviceInfo.indexOf(AppConstants.separatorByte);
    if (indexSeparator == -1) {
      return utf8.decode(fullDeviceInfo);
    }
    var deviceName = fullDeviceInfo.sublist(0, indexSeparator);
    return utf8.decode(deviceName);
  }

  int getSignatureBytes(Device device) {
    var fullDeviceInfo = device.endpointName;
    var indexSeparator = fullDeviceInfo.indexOf(AppConstants.separatorByte);
    if (indexSeparator == -1) {
      return 0;
    }
    var signature = fullDeviceInfo.sublist(indexSeparator + 1);
    return signature.length;
  }
}
