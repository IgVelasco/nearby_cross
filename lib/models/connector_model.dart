import 'package:flutter/services.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:logger/logger.dart';

import '../helpers/permission_manager.dart';

class Connector {
  var logger = Logger();
  NearbyCross nearbyCross = NearbyCross();
  Map<String, Device> listOfConnectedDevices = {};
  Map<String, Device> listOfInitiatedConnections = {};

  Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  Future<String?> getPlatformVersion() async {
    return nearbyCross.getPlatformVersion();
  }

  Future<void> connect(String endpointId) async {
    await nearbyCross.connect(endpointId);
  }

  Future<void> sendData(String data) async {
    await nearbyCross.sendData(data);
  }

  Future<void> disconnect(String serviceId) async {
    await nearbyCross.disconnect(serviceId);
  }

  Connector(Function(Connector, MethodCall)? extenseMethodCall) {
    nearbyCross.setMethodCallHandler((call) async {
      this.logger.i(
          "Received onEndpointFound from Kotlin: ${call.arguments["endpointName"] as String}");
      if (extenseMethodCall != null) {
        await extenseMethodCall(this, call);
      }

      if (call.method == 'payloadReceived') {
        var arguments = call.arguments as Map<Object?, Object?>;
        logger.i("Received Payload $arguments");
        var messageReceived = arguments["message"] as String;
        var endpointId = arguments["endpointId"] as String;

        listOfConnectedDevices[endpointId]?.addMessage(messageReceived);
      }
    });
  }
}
