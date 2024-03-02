import 'package:flutter/material.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';

class AdvertiserComunicationViewModel extends ChangeNotifier {
  Device? lastDeviceMessage;
  Device? recentConnectedDevice;
  bool alreadyAskedForRecentConnectedDevice = false;

  late ConnectionsManager connectionsManager;
  AdvertiserComunicationViewModel() {
    connectionsManager = ConnectionsManager();

    connectionsManager
        .setCallbackSuccessfulConnection(_callbackSuccessfulConnection);

    connectionsManager.getAllConnectedDevices().forEach((device) =>
        connectionsManager.setCallbackReceivedMessage(
            device.endpointId, _callbackReceivedMessage));
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void _callbackSuccessfulConnection(Device device) {
    connectionsManager.setCallbackReceivedMessage(
        device.endpointId, _callbackReceivedMessage);
    recentConnectedDevice = device;
    alreadyAskedForRecentConnectedDevice = false;
    _commonCallback(device);
  }

  void _callbackReceivedMessage(Device device) {
    lastDeviceMessage = device;
    _commonCallback(device);
  }

  void setAlreadyAskedForRecentConnectedDevice(bool value) {
    alreadyAskedForRecentConnectedDevice = value;
  }

  String? getRecentConnectedDeviceName() {
    if (recentConnectedDevice != null &&
        !alreadyAskedForRecentConnectedDevice) {
      return recentConnectedDevice!.endpointName;
    }

    return null;
  }

  String? getLastMessageDeviceName() {
    return lastDeviceMessage?.endpointName;
  }

  void sendDataToDevices(String message) {
    connectionsManager.broadcastMessage(NearbyMessage.fromString(message));
  }

  NearbyMessage? getLastMessage() {
    return lastDeviceMessage?.getLastMessage();
  }
}
