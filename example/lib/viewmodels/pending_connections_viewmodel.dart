import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross_example/constants/app.constants.dart';

class PendingConnectionsViewModel with ChangeNotifier {
  Logger logger = Logger();
  late ConnectionsManager connectionsManager;

  PendingConnectionsViewModel() {
    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackPendingAcceptConnection(
        "PendingConnectionsViewModel:pendingAcceptConnection",
        _setCallbackPendingAcceptConnection);

    connectionsManager.setCallbackSuccessfulConnection(
        "PendingConnectionsViewModel:successfulConnection",
        _setCallbackSuccessfulConnection);

    connectionsManager.setCallbackConnectionRejected(
        "PendingConnectionsViewModel:connectionRejected",
        _setCallbackConnectionRejected);
  }

  @override
  void dispose() {
    connectionsManager.removeNamedCallback(
        "PendingConnectionsViewModel:pendingAcceptConnection");
    connectionsManager.removeNamedCallback(
        "PendingConnectionsViewModel:successfulConnection");
    connectionsManager
        .removeNamedCallback("PendingConnectionsViewModel:connectionRejected");
    super.dispose();
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _setCallbackPendingAcceptConnection(Device device) {
    logger.i("Device ${device.endpointName} wants to connect");
    _commonCallback(device);
  }

  void _setCallbackSuccessfulConnection(Device device) {
    logger.i("Device ${device.endpointName} is successfully connected");
    _commonCallback(device);
  }

  void _setCallbackConnectionRejected(Device device) {
    logger.i("Device ${device.endpointName} was rejected");
    _commonCallback(device);
  }

  int getPendingConnectionsCount() {
    return connectionsManager.pendingAcceptConnections.length;
  }

  List<Device> getPendingConnectionsDevices() {
    return connectionsManager.pendingAcceptConnections.toList();
  }

  Future<void> acceptConnection(String endpointId) {
    return connectionsManager.acceptConnection(endpointId);
  }

  Future<void> rejectConnection(String endpointId) {
    return connectionsManager.rejectConnection(endpointId);
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
}
