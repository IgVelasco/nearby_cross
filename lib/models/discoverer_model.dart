import 'package:nearby_cross/models/connector_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

class Discoverer extends Connector {
  static Discoverer? _singleton;
  Set<Device> listOfDiscoveredDevices = {};
  Function(Device) callbackOnDeviceFound = (_) => {};

  factory Discoverer() {
    _singleton ??= Discoverer._internal();

    return _singleton!;
  }

  void _handleEndpointFound(String endpointId, String endpointName) {
    logger.i("Found Device $endpointId $endpointName");

    var device = Device(endpointId, endpointName);
    listOfDiscoveredDevices.add(Device(endpointId, endpointName));

    logger.i("List of devices $listOfDiscoveredDevices");

    callbackOnDeviceFound(device);
  }

  void setOnDeviceFoundCallback(Function(Device) callbackOnDeviceFound) {
    this.callbackOnDeviceFound = callbackOnDeviceFound;
  }

  Future<void> startDiscovery(String? username) async {
    listOfDiscoveredDevices.clear();
    await nearbyCross.startDiscovery(serviceId, username);
  }

  Discoverer._internal() : super() {
    nearbyCross.setMethodCallHandler(NearbyCrossMethods.onEndpointFound,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      return _handleEndpointFound(arguments["endpointId"] as String,
          arguments["endpointName"] as String);
    });
  }
}
