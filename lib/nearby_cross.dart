import 'package:flutter/services.dart';

import 'nearby_cross_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyCross {
  static const MethodChannel _channel = MethodChannel('nearby_cross');

  get methodChannel => _channel;

  static Future<void> requestPermissions() async {
    // Request permission to access location
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.location,
      Permission.bluetooth,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise
    ].request();

    // Check the permission status after the request
    // if (permissionStatus[Permission.location] != PermissionStatus.granted) {
    //   throw Exception('Location permission not granted');
    // }

    // if (permissionStatus[Permission.bluetooth] != PermissionStatus.granted) {
    //   throw Exception('Bluetooth permission not granted');
    // }
  }

  Future<String?> getPlatformVersion() {
    return NearbyCrossPlatform.instance.getPlatformVersion();
  }

  static Future<Color> generateColor() async {
    final randomColor = await _channel.invokeMethod('generateColor');
    return Color.fromRGBO(randomColor[0], randomColor[1], randomColor[2], 1.0);
  }

  static Future<void> startDiscovery(String serviceId) async {
    await _channel.invokeMethod('startDiscovery', serviceId);
  }

  static Future<void> advertise(String serviceId) async {
    await _channel.invokeMethod('startAdvertising', serviceId);
  }

  static Future<void> disconnect(String serviceId) async {
    await _channel.invokeMethod('disconnect', serviceId);
  }
}
