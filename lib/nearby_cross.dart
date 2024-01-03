import 'package:flutter/services.dart';
import 'package:nearby_cross/helpers/permission_manager.dart';

import 'nearby_cross_method_channel.dart';

class NearbyCross {
  static final MethodChannelNearbyCross nearbyChannel =
      MethodChannelNearbyCross();

  get methodChannel => nearbyChannel;

  static Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  Future<String?> getPlatformVersion() async {
    return nearbyChannel.getPlatformVersion();
  }

  Future<void> startDiscovery(String serviceId, String? username) async {
    await nearbyChannel.startDiscovery(serviceId, username);
  }

  Future<void> advertise(String serviceId, String? username) async {
    await nearbyChannel.advertise(serviceId, username);
  }

  Future<void> disconnect(String serviceId) async {
    await nearbyChannel.disconnect(serviceId);
  }

  Future<void> sendData(String data) async {
    await nearbyChannel.sendData(data);
  }

  Future<void> setMethodCallHandler(
      Future<dynamic> Function(MethodCall) handler) async {
    await nearbyChannel.setMethodCallHandler(handler);
  }

  Future<void> connect(String endpointId) async {
    await nearbyChannel.connect(endpointId);
  }
}
