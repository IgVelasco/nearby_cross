import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross/helpers/permission_manager.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

class NearbyCross {
  @visibleForTesting
  var logger = Logger();
  late MethodChannel methodChannel;
  static NearbyCross? _singleton;
  Map<String, List<Function(MethodCall)>> methodCallHandlers = {};

  factory NearbyCross() {
    _singleton ??= NearbyCross._internal();

    return _singleton!;
  }

  NearbyCross._internal() {
    methodChannel = const MethodChannel('nearby_cross');
    for (var method in NearbyCrossMethods.values) {
      methodCallHandlers[method.getString()] = [];
    }

    methodChannel.setMethodCallHandler((call) async {
      if (methodCallHandlers.containsKey(call.method)) {
        var handlers = methodCallHandlers[call.method];
        await Future.wait(handlers!.map(
          (e) async => await e(call),
        ));
      } else {
        logger.i("Received unknown method call: ${call.method}");
      }
    });
  }

  static Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> startDiscovery(String serviceId, String? username,
      [NearbyStrategies strategy = NearbyStrategies.star]) async {
    await methodChannel.invokeMethod('startDiscovery', {
      'serviceId': serviceId,
      'username': username ?? 'generic_discoverer_name',
      'strategy': strategy.toStrategyString()
    });
  }

  Future<void> advertise(
      String serviceId, String? username, bool manualAcceptConnections,
      [NearbyStrategies strategy = NearbyStrategies.star]) async {
    await methodChannel.invokeMethod('startAdvertising', {
      'serviceId': serviceId,
      'username': username ?? 'generic_advertiser_name',
      'strategy': strategy.toStrategyString(),
      'manualAcceptConnections': manualAcceptConnections ? "1" : "0"
    });
  }

  Future<void> stopAllConnections() async {
    // TODO: implement
    await methodChannel.invokeMethod('stopAllConnections');
  }

  Future<void> disconnectFrom(String serviceId) async {
    // TODO: implement
    // await methodChannel.invokeMethod('disconnectFrom', serviceId);
  }

  Future<void> stopDiscovering() async {
    await methodChannel.invokeMethod('stopDiscovering');
  }

  Future<void> stopAdvertising() async {
    await methodChannel.invokeMethod('stopAdvertising');
  }

  Future<void> sendData(Uint8List data, String endpointId) async {
    await methodChannel
        .invokeMethod('sendData', {"data": data, "endpointId": endpointId});
  }

  void setMethodCallHandler(
      NearbyCrossMethods method, Future<dynamic> Function(MethodCall) handler) {
    if (methodCallHandlers.containsKey(method.getString())) {
      methodCallHandlers[method.getString()]!.add(handler);
    }
  }

  Future<void> connect(String endpointId) async {
    await methodChannel.invokeMethod('connect', {"endpointId": endpointId});
  }

  Future<void> acceptConnection(String endpointId) async {
    await methodChannel
        .invokeMethod('acceptConnection', {"endpointId": endpointId});
  }

  Future<void> rejectConnection(String endpointId) async {
    await methodChannel
        .invokeMethod('rejectConnection', {"endpointId": endpointId});
  }
}
