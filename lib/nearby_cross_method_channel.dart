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
  Future<void> startDiscovery(String serviceId, String? username) async {
    await methodChannel.invokeMethod('startDiscovery', {
      'serviceId': serviceId,
      'username': username ?? 'generic_discoverer_name',
      'strategy': 'P2P_STAR'
    });
  }

  @override
  Future<void> advertise(String serviceId, String? username) async {
    await methodChannel.invokeMethod('startAdvertising', {
      'serviceId': serviceId,
      'username': username ?? 'generic_advertiser_name',
      'strategy': 'P2P_STAR'
    });
  }

  @override
  Future<void> disconnect(String serviceId) async {
    await methodChannel.invokeMethod('disconnect', serviceId);
  }

  @override
  Future<void> sendData(String data) async {
    await methodChannel.invokeMethod('sendData', data);
  }

  setMethodCallHandler(Future<dynamic> Function(MethodCall) handler) {
    methodChannel.setMethodCallHandler(handler);
  }

  @override
  Future<void> connect(String endpointId) async {
    await methodChannel.invokeMethod('connect', {"endpointId": endpointId});
  }
}
