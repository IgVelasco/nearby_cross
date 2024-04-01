import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class SelectInteractionViewModel with ChangeNotifier {
  Logger logger = Logger();
  late ConnectionsManager connectionsManager;

  SelectInteractionViewModel() {
    connectionsManager = ConnectionsManager();
    setCallbacks();
  }

  @override
  void dispose() {
    connectionsManager
        .removeNamedCallback("SelectInteractionViewModel:successfulConnection");
    connectionsManager
        .removeNamedCallback("SelectInteractionViewModel:receivedMessage");
    super.dispose();
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void setCallbacks() {
    connectionsManager.setCallbackSuccessfulConnection(
        "SelectInteractionViewModel:successfulConnection",
        _setCallbackSuccessfulConnection);
    connectionsManager.setCallbackReceivedMessage(
        "SelectInteractionViewModel:receivedMessage",
        _setCallbackReceivedMessage);
    connectionsManager.setCallbackDisconnectedDevice(
        "SelectInteractionViewModel:disconnectedDevice",
        _setCallbackDisconnectedDevice);
  }

  Future<void> afterNavigationPop() async {
    setCallbacks();
    notifyListeners();
  }

  Future<void> refreshConnectedList() async {
    notifyListeners();
  }

  void _setCallbackSuccessfulConnection(Device device) {
    logger.i("Device ${device.endpointName} is successfully connected");
    _commonCallback(device);
  }

  void _setCallbackReceivedMessage(Device device) {
    logger.i("New messages from ${device.endpointName}");
    _commonCallback(device);
  }

  void _setCallbackDisconnectedDevice(Device device) {
    logger.i("Disconnected device ${device.endpointName}");
    _commonCallback(device);
  }

  int getTotalConnectionsCount() {
    return connectionsManager.connectedDevices.length;
  }

  Device getConnectedDeviceByIndex(int index) {
    return connectionsManager.connectedDevices.toList()[index];
  }

  Future<void> disconnectFrom(Device device) {
    return connectionsManager.disconnectFromEndpoint(device.endpointId);
  }
}
