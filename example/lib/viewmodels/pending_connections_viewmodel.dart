import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class PendingConnectionsViewModel with ChangeNotifier {
  Logger logger = Logger();
  late ConnectionsManager connectionsManager;

  PendingConnectionsViewModel() {
    connectionsManager = ConnectionsManager();
    connectionsManager.setCallbackPendingAcceptConnection(
        _setCallbackPendingAcceptConnection);

    connectionsManager
        .setCallbackSuccessfulConnection(_setCallbackSuccessfulConnection);

    connectionsManager
        .setCallbackConnectionRejected(_setCallbackConnectionRejected);
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
}
