import 'package:flutter/material.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class DiscovererComunicationViewModel extends ChangeNotifier {
  late Device? connectedDevice;
  String? lastMessage;
  DiscovererComunicationViewModel(String endpointId) {
    var connectionsManager = ConnectionsManager();
    connectedDevice = connectionsManager.getConnectedDevice(endpointId);

    connectionsManager.setCallbackReceivedMessage(
        endpointId, _callbackReceivedMessage);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    lastMessage = device.getLastMessage();
    _commonCallback(device);
  }

  String? getConnectedDeviceName() {
    return connectedDevice?.endpointName;
  }

  void sendData(String message) {
    connectedDevice?.sendMessage(message);
  }

  String? getLastMessage() {
    return lastMessage;
  }
}
