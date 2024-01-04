import 'package:flutter/services.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross.dart';

import '../helpers/permission_manager.dart';

class Connector {
  NearbyCross nearbyCross = NearbyCross();
  Map<String, Device> listOfConnectedDevices = {};
  Map<String, Device> listOfInitiatedConnections = {};

  static Future<void> requestPermissions() async {
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

  /* 
    TODO: Method call handler should be set in the View Model class
  */
  Future<void> setMethodCallHandler(
      Future<dynamic> Function(MethodCall) handler) async {
    await nearbyCross.setMethodCallHandler(handler);
  }
}
