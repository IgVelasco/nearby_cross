import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nearby_cross_platform_interface.dart';

/// An implementation of [NearbyCrossPlatform] that uses method channels.
class MethodChannelNearbyCross extends NearbyCrossPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nearby_cross');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Color> generateColor() async {
    final randomColor =
        await methodChannel.invokeMethod<List<int>>('generateColor');
    if (randomColor == null) {
      throw Exception('Invalid color format');
    }
    return Color.fromRGBO(randomColor[0], randomColor[1], randomColor[2], 1.0);
  }

  @override
  Future<void> startDiscovery(String serviceId) async {
    await methodChannel.invokeMethod('startDiscovery', serviceId);
  }

  @override
  Future<void> advertise(String serviceId, String? username) async {
    await methodChannel.invokeMethod('startAdvertising',
        {'serviceId': serviceId, 'username': username ?? 'generic_name'});
  }

  @override
  Future<void> disconnect(String serviceId) async {
    await methodChannel.invokeMethod('disconnect', serviceId);
  }

  @override
  Future<void> sendData(String data) async {
    await methodChannel.invokeMethod('sendData', data);
  }

  @override
  Future<void> sendDataUsername(String username, String data) async {
    await methodChannel.invokeMethod('sendDataUsername', {data, username });
  }

  setMethodCallHandler(Future<dynamic> Function(MethodCall) handler) {
    methodChannel.setMethodCallHandler(handler);
  }
}
