import 'dart:convert';
import 'dart:typed_data';

import 'package:nearby_cross/constants/nearby_constraints.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross/errors/device_info_too_large.error.dart';
import 'package:nearby_cross/models/connector_model.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/nearby_cross_methods.dart';

/// Class that represent the Discoverer instance of NearbyCross plugin.
class Discoverer extends Connector {
  static Discoverer? _singleton;

  /// List of devices discovered by the Discoverer
  Set<Device> listOfDiscoveredDevices = {};

  /// Custom callback to execute when a device is found
  Function(Device) callbackOnDeviceFound = (_) => {};

  /// Custom callback to execute when a device is lost
  Function(Device) callbackOnDeviceLost = (_) => {};

  /// Boolean value that returns if the device is discovering other devices
  bool isDiscovering = false;

  /// Implements singleton pattern
  factory Discoverer() {
    _singleton ??= Discoverer._internal();

    return _singleton!;
  }

  /// Handler for [NearbyCrossMethods.onEndpointFound] method call
  /// - Adds a device as a discovered device in listOfDiscoveredDevices
  /// - Executes callbackOnDeviceFound
  void _handleEndpointFound(String endpointId, Uint8List endpointName) {
    var device = Device.asEndpoint(endpointId, endpointName);
    listOfDiscoveredDevices.add(device);

    callbackOnDeviceFound(device);
  }

  /// Handler for [NearbyCrossMethods.onEndpointLost] method call
  /// - Removes a device from listOfDiscoveredDevices
  /// - Executes callbackOnDeviceLost
  void _handleEndpointLost(String endpointId) {
    var device = listOfDiscoveredDevices
        .firstWhere((element) => element.endpointId == endpointId);

    listOfDiscoveredDevices.remove(device);
    callbackOnDeviceLost(device);
  }

  /// Handler for [NearbyCrossMethods.connectionRejected] method call
  /// - Removes a device from listOfDiscoveredDevices
  void _handleConnectionRejected(String endpointId) {
    var device = listOfDiscoveredDevices
        .firstWhere((element) => element.endpointId == endpointId);

    listOfDiscoveredDevices.remove(device);
  }

  /// Service to configure callbackOnDeviceFound, that executes every time a new device is found
  void setOnDeviceFoundCallback(Function(Device) callbackOnDeviceFound) {
    this.callbackOnDeviceFound = callbackOnDeviceFound;
  }

  /// Service to start discovering devices using NearbyCross plugin
  Future<void> startDiscovery(String serviceId,
      {NearbyStrategies strategy = NearbyStrategies.star}) async {
    if (deviceInfo.length > NearbyConstraints.deviceInfoMaxBytes) {
      throw const DeviceInfoTooLarge(NearbyConstraints.deviceInfoMaxBytes);
    }
    listOfDiscoveredDevices.clear();
    await nearbyCross.startDiscovery(serviceId, deviceInfo, strategy);
    isDiscovering = true;
  }

  Future<void> stopDiscovering() async {
    await nearbyCross.stopDiscovering();
    isDiscovering = false;
  }

  int getNumberOfDiscoveredDevices() {
    return listOfDiscoveredDevices.length;
  }

  Discoverer._internal() : super() {
    nearbyCross.setMethodCallHandler(NearbyCrossMethods.onEndpointFound,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      var endpointName = arguments["endpointName"] as Uint8List;
      logger.d("Endpoint ID: $endpointId\nEndpoint Name: $endpointName");

      return _handleEndpointFound(endpointId, endpointName);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.onEndpointLost,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      var endpointId = utf8.decode(arguments["endpointId"] as Uint8List);
      return _handleEndpointLost(endpointId);
    });

    nearbyCross.setMethodCallHandler(NearbyCrossMethods.connectionRejected,
        (call) async {
      var arguments = call.arguments as Map<Object?, Object?>;
      return _handleConnectionRejected(arguments["endpointId"] as String);
    });
  }
}
