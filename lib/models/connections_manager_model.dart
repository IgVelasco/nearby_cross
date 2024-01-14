import 'package:logger/logger.dart';
import 'package:nearby_cross/models/device_model.dart';

class ConnectionsManager {
  var logger = Logger();
  static ConnectionsManager? _singleton;
  Set<Device> initiatedConnections = {};
  Set<Device> connectedDevices = {};

  factory ConnectionsManager() {
    _singleton ??= ConnectionsManager._internal();

    return _singleton!;
  }

  ConnectionsManager._internal();

  Device? _findDevice(Iterable iterable, String endpointId) {
    try {
      Device device =
          iterable.firstWhere((device) => device.endpointId == endpointId);
      return device;
    } catch (_) {
      return null;
    }
  }

  Device addInitiatedConnection(String endpointId, String endpointName) {
    var device = Device(endpointId, endpointName);
    initiatedConnections.add(device);
    return device;
  }

  Device? addConnectedDevice(String endpointId) {
    Device? device = _findDevice(initiatedConnections, endpointId);
    if (device == null) {
      logger.e(
          "Could not find a initiated connection from endpointID $endpointId");
      return null;
    }

    connectedDevices.add(device);
    initiatedConnections.remove(device);

    return device;
  }

  Device? addMessageFromDevice(String endpointId, String message) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return null;
    }

    device.addMessage(message);
    return device;
  }

  void sendMessageToDevice(String endpointId, String message) {
    Device? device = _findDevice(connectedDevices, endpointId);
    if (device == null) {
      logger.e("Could not find device $endpointId");
      return;
    }

    device.sendMessage(message);
  }

  void broadcastMessage(String message) {
    for (var device in connectedDevices) {
      device.sendMessage(message);
    }
  }
}
