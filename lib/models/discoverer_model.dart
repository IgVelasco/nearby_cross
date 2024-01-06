import 'package:flutter/services.dart';
import 'package:nearby_cross/models/connector_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class Discoverer extends Connector {
  Map<String, Device> listOfDiscoveredDevices = {};

  static void _handleEndpointFound(
      Discoverer instance, String endpointId, String endpointName) {
    instance.logger.i("Found Device $endpointId $endpointName");

    instance.listOfDiscoveredDevices[endpointId] =
        Device(endpointId, endpointName);

    instance.logger.i("List of devices ${instance.listOfDiscoveredDevices}");
  }

  Future<void> startDiscovery(String serviceId, String? username) async {
    await nearbyCross.startDiscovery(serviceId, username);
  }

  Discoverer()
      : super((Connector instance, MethodCall call) {
          if (call.method == 'onEndpointFound') {
            var arguments = call.arguments as Map<Object?, Object?>;
            instance.logger.i(
                "Received onEndpointFound from Kotlin: ${arguments["endpointName"] as String}");
            return _handleEndpointFound(
                instance as Discoverer,
                arguments["endpointId"] as String,
                arguments["endpointName"] as String);
          }
        });
}
