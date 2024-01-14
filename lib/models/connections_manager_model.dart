import 'package:logger/logger.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

class ConnectionsManager {
  var logger = Logger();
  static ConnectionsManager? _singleton;
  NearbyCross nearbyCross = NearbyCross();
  Set<Device> initiatedConnections = {};
  Set<Device> connectedDevices = {};

  Function(Device) callbackConnectionInitiated = (_) => {};
  Function(Device) callbackSuccessfulConnection = (_) => {};
  Function(Device) callbackReceivedMessage = (_) => {};

  factory ConnectionsManager() {
    _singleton ??= ConnectionsManager._internal();

    return _singleton!;
  }

  ConnectionsManager._internal() {
    nearbyCross.setMethodCallHandler(NearbyCrossMethods.connectionInitiated,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = arguments["endpointId"] as String;
      var endpointName = arguments["endpointName"] as String;

      var device = addInitiatedConnection(endpointId, endpointName);
      callbackConnectionInitiated(device);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.successfulConnection,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = arguments["endpointId"] as String;
      var device = addConnectedDevice(endpointId);
      if (device == null) {
        return;
      }

      callbackSuccessfulConnection(device);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.payloadReceived,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var messageReceived = arguments["message"] as String;
      var endpointId = arguments["endpointId"] as String;

      var device = addMessageFromDevice(endpointId, messageReceived);
      if (device == null) {
        return;
      }

      callbackReceivedMessage(device);
    });
  }

  void setCallbackConnectionInitiated(
      Function(Device) callbackConnectionInitiated) {
    this.callbackConnectionInitiated = callbackConnectionInitiated;
  }

  void setCallbackSuccessfulConnection(
      Function(Device) callbackSuccessfulConnection) {
    this.callbackSuccessfulConnection = callbackSuccessfulConnection;
  }

  void setCallbackReceivedMessage(Function(Device) callbackReceivedMessage) {
    this.callbackReceivedMessage = callbackReceivedMessage;
  }

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
