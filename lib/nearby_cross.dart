import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nearby_cross/helpers/permission_manager.dart';

class NearbyCross {
  @visibleForTesting
  final methodChannel = const MethodChannel('nearby_cross');

  static Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> startDiscovery(String serviceId, String? username) async {
    await methodChannel.invokeMethod('startDiscovery', {
      'serviceId': serviceId,
      'username': username ?? 'generic_discoverer_name',
      'strategy': 'P2P_STAR'
    });
  }

  Future<void> advertise(String serviceId, String? username) async {
    await methodChannel.invokeMethod('startAdvertising', {
      'serviceId': serviceId,
      'username': username ?? 'generic_advertiser_name',
      'strategy': 'P2P_STAR'
    });
  }

  Future<void> disconnect(String serviceId) async {
    await methodChannel.invokeMethod('disconnect', serviceId);
  }

  Future<void> sendData(String data) async {
    await methodChannel.invokeMethod('sendData', data);
  }

  Future<void> setMethodCallHandler(
      Future<dynamic> Function(MethodCall) handler) async {
    methodChannel.setMethodCallHandler(handler);
  }

  Future<void> connect(String endpointId) async {
    await methodChannel.invokeMethod('connect', {"endpointId": endpointId});
  }
}
