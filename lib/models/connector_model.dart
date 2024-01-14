import 'package:flutter/services.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

import '../helpers/permission_manager.dart';

class Connector {
  var logger = Logger();
  String? platformVersion;
  NearbyCross nearbyCross = NearbyCross();
  ConnectionsManager connectionsManager = ConnectionsManager();

  String serviceId = 'com.example.nearbyCrossExample';

  // void setCallbackConnectionInitiated(
  //     Function(Device) callbackConnectionInitiated) {
  //   this.callbackConnectionInitiated = callbackConnectionInitiated;
  // }

  // void setCallbackSuccessfulConnection(
  //     Function(Device) callbackSuccessfulConnection) {
  //   this.callbackSuccessfulConnection = callbackSuccessfulConnection;
  // }

  // void setCallbackReceivedMessage(Function(Device) callbackReceivedMessage) {
  //   this.callbackReceivedMessage = callbackReceivedMessage;
  // }

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

  Connector();
}
