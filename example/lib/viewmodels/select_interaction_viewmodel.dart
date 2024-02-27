import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class SelectInteractionViewModel with ChangeNotifier {
  Logger logger = Logger();
  late ConnectionsManager connectionsManager;

  SelectInteractionViewModel() {
    connectionsManager = ConnectionsManager();

    connectionsManager
        .setCallbackSuccessfulConnection(_setCallbackSuccessfulConnection);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  Future<void> refreshConnectedList() async {
    notifyListeners();
    return;
  }

  void _setCallbackSuccessfulConnection(Device device) {
    logger.i("Device ${device.endpointName} is successfully connected");
    _commonCallback(device);
  }

  int getTotalConnectionsCount() {
    return connectionsManager.connectedDevices.length;
  }

  Device getConnectedDeviceByIndex(int index) {
    return connectionsManager.connectedDevices.toList()[index];
  }
}
