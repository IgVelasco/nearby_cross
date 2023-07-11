import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:nearby_cross/helpers/permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<Color> generateColor() async {
    return await nearbyChannel.generateColor();
  }

  Future<void> startDiscovery(String serviceId) async {
    await nearbyChannel.startDiscovery(serviceId);
  }

  Future<void> advertise(String serviceId) async {
    await nearbyChannel.advertise(serviceId);
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
}
