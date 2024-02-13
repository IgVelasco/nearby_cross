import 'package:nearby_cross/models/connector_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

/// Class that represent the Discoverer instance of NearbyCross plugin.
class Discoverer extends Connector {
  static Discoverer? _singleton;
  Set<Device> listOfDiscoveredDevices = {};
  Function(Device) callbackOnDeviceFound = (_) => {};
  bool isDiscovering = false;

  /// Implements singleton pattern
  factory Discoverer() {
    _singleton ??= Discoverer._internal();

    return _singleton!;
  }

  /// Handler for [NearbyCrossMethods.onEndpointFound] method call
  /// Adds a device as a discovered device in listOfDiscoveredDevices
  void _handleEndpointFound(String endpointId, String endpointName) {
    var device = Device.asEndpoint(endpointId, endpointName);
    listOfDiscoveredDevices.add(device);

    callbackOnDeviceFound(device);
  }

  /// Service to configure callbackOnDeviceFound, that executes every time a new device is found
  void setOnDeviceFoundCallback(Function(Device) callbackOnDeviceFound) {
    this.callbackOnDeviceFound = callbackOnDeviceFound;
  }

  /// Service to start discovering devices using NearbyCross plugin
  Future<void> startDiscovery(String? username) async {
    listOfDiscoveredDevices.clear();
    await nearbyCross.startDiscovery(serviceId, username);
    isDiscovering = true;
    this.username = username;
  }

  Future<void> stopDiscovering() async {
    await nearbyCross.stopDiscovering();
    isDiscovering = false;
  }

  Future<void> connectionsRemoved() async {
    isDiscovering = false;
  }

  int getNumberOfDiscoveredDevices() {
    return listOfDiscoveredDevices.length;
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
