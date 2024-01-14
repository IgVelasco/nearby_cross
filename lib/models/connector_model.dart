import 'package:flutter/services.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:logger/logger.dart';

import '../helpers/permission_manager.dart';

class Connector {
  var logger = Logger();
  String? platformVersion;
  NearbyCross nearbyCross = NearbyCross();
  ConnectionsManager connectionsManager = ConnectionsManager();

  Function(Device) callbackConnectionInitiated = (_) => {};
  Function(Device) callbackSuccessfulConnection = (_) => {};
  Function(Device) callbackReceivedMessage = (_) => {};

  String serviceId = 'com.example.nearbyCrossExample';

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

  Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  Future<String?> getPlatformVersion() async {
    platformVersion = await nearbyCross.getPlatformVersion();
    return platformVersion;
  }

  Future<void> connect(String endpointId) async {
    await nearbyCross.connect(endpointId);
  }

  Future<void> disconnect() async {
    await nearbyCross.disconnect(serviceId);
  }

  Connector(Function(Connector, MethodCall)? extenseMethodCall) {
    nearbyCross.setMethodCallHandler((call) async {
      if (extenseMethodCall != null) {
        await extenseMethodCall(this, call);
      }

      if (call.method == 'payloadReceived') {
        var arguments = call.arguments as Map<Object?, Object?>;
        var messageReceived = arguments["message"] as String;
        var endpointId = arguments["endpointId"] as String;

        var device = connectionsManager.addMessageFromDevice(
            endpointId, messageReceived);
        if (device == null) {
          return;
        }

        callbackReceivedMessage(device);
      } else if (call.method == 'connectionInitiated') {
        var arguments = call.arguments as Map<Object?, Object?>;

        var endpointId = arguments["endpointId"] as String;
        var endpointName = arguments["endpointName"] as String;

        var device =
            connectionsManager.addInitiatedConnection(endpointId, endpointName);
        callbackConnectionInitiated(device);
      } else if (call.method == 'successfulConnection') {
        var arguments = call.arguments as Map<Object?, Object?>;
        var endpointId = arguments["endpointId"] as String;
        var device = connectionsManager.addConnectedDevice(endpointId);
        if (device == null) {
          return;
        }

        callbackSuccessfulConnection(device);
      } else {
        logger.i("Received callback: ${call.method}");
      }
    });
  }
}
