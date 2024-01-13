import 'package:flutter/services.dart';
import 'package:nearby_cross/models/connector_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class Discoverer extends Connector {
  static Discoverer? _singleton;
  Set<Device> listOfDiscoveredDevices = {};
  Function(Device)? callbackOnDeviceFound;

  factory Discoverer() {
    _singleton ??= Discoverer._internal();

    return _singleton!;
  }

  static void _handleEndpointFound(
      Discoverer instance, String endpointId, String endpointName) {
    instance.logger.i("Found Device $endpointId $endpointName");

    var device = Device(endpointId, endpointName);
    instance.listOfDiscoveredDevices.add(Device(endpointId, endpointName));

    instance.logger.i("List of devices ${instance.listOfDiscoveredDevices}");

    if (instance.callbackOnDeviceFound != null) {
      instance.callbackOnDeviceFound!(device);
    }
  }

  void setOnDeviceFoundCallback(Function(Device) callbackOnDeviceFound) {
    this.callbackOnDeviceFound = callbackOnDeviceFound;
  }

  Future<void> startDiscovery(String? username) async {
    listOfDiscoveredDevices.clear();
    await nearbyCross.startDiscovery(serviceId, username);
  }

  Discoverer._internal()
      : super((Connector instance, MethodCall call) {
          if (call.method == 'onEndpointFound') {
            var arguments = call.arguments as Map<Object?, Object?>;
            return _handleEndpointFound(
                instance as Discoverer,
                arguments["endpointId"] as String,
                arguments["endpointName"] as String);
          }
        });
}
