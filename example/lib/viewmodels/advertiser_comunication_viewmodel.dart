import 'package:flutter/material.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class AdvertiserComunicationViewModel extends ChangeNotifier {
  Device? lastDeviceMessage;
  late ConnectionsManager connectionsManager;
  AdvertiserComunicationViewModel() {
    connectionsManager = ConnectionsManager();

    connectionsManager.getAllConnectedDevices().map((device) =>
        connectionsManager.setCallbackReceivedMessage(
            device.endpointId, _callbackReceivedMessage));
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackReceivedMessage(Device device) {
    lastDeviceMessage = device;
    _commonCallback(device);
  }

  String? getLastMessageDeviceName() {
    return lastDeviceMessage?.endpointName;
  }

  void sendDataToDevices(String message) {
    connectionsManager.broadcastMessage(message);
  }

  String? getLastMessage() {
    return lastDeviceMessage?.getLastMessage();
  }
}
