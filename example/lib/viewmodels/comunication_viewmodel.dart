import 'package:flutter/material.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class ComunicationViewModel extends ChangeNotifier {
  Device connectedDevice;
  String? lastMessage;
  ComunicationViewModel(this.connectedDevice) {
    var connectionsManager = ConnectionsManager();

    connectionsManager.setCallbackReceivedMessage(
        connectedDevice.endpointId, _callbackReceivedMessage);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    lastMessage = device.getLastMessage();
    _commonCallback(device);
  }

  String? getConnectedDeviceName() {
    return connectedDevice.endpointName;
  }

  void sendData(String message) {
    connectedDevice.sendMessage(message);
  }

  String? getLastMessage() {
    return lastMessage;
  }

  List<String> getLastMessages() {
    return [
      "A",
      "B",
      "C",
      "D",
      "E",
      "A",
      "B",
      "C",
      "D",
      "E",
      "A",
      "B",
      "C",
      "D",
      "E"
    ];
  }
}
