import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'nearby_cross_method_channel.dart';

class NearbyCross {
  static final MethodChannelNearbyCross _methodChannel =
      MethodChannelNearbyCross();

  static Future<void> requestPermissions() async {
    // Request permission to access location
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.location,
      Permission.bluetooth,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();

    // Check the permission status after the request
    // if (permissionStatus[Permission.location] != PermissionStatus.granted) {
    //   throw Exception('Location permission not granted');
    // }

    // if (permissionStatus[Permission.bluetooth] != PermissionStatus.granted) {
    //   throw Exception('Bluetooth permission not granted');
    // }
  }

  Future<String?> getPlatformVersion() async {
    return _methodChannel.getPlatformVersion();
  }

  Future<Color> generateColor() async {
    return await _methodChannel.generateColor();
  }

  Future<void> startDiscovery(String serviceId) async {
    await _methodChannel.startDiscovery(serviceId);
  }

  Future<void> advertise(String serviceId) async {
    await _methodChannel.advertise(serviceId);
  }

  Future<void> disconnect(String serviceId) async {
    await _methodChannel.disconnect(serviceId);
  }

  Future<void> sendData(String data) async {
    await _methodChannel.sendData(data);
  }
}
