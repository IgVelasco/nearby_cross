import 'dart:typed_data';

import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:logger/logger.dart';

import '../helpers/permission_manager.dart';

class Connector {
  var logger = Logger();

  /// The platform version of the native code
  String? platformVersion;

  /// The device info of the current device
  Uint8List deviceInfo = Uint8List(0);

  /// The NearbyCross instance
  NearbyCross nearbyCross = NearbyCross();

  /// The ConnectionsManager instance
  ConnectionsManager connectionsManager = ConnectionsManager();

  /// Boolean value that returns if the device is connected to another device
  bool get isConnected => connectionsManager.connectedDevices.isNotEmpty;

  /// Function that request permissions necessary for the plugin to work
  Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  /// Returns the platform version of the native code
  Future<String?> getPlatformVersion() async {
    platformVersion = await nearbyCross.getPlatformVersion();
    return platformVersion;
  }

  Future<void> connect(String endpointId) async {
    await nearbyCross.connect(endpointId);
  }

  /// Disconnects from the given endpoint
  Future<void> disconnectFrom(String endpointId) async {
    await nearbyCross.disconnectFrom(endpointId);
  }

  /// Stops all connections
  Future<void> stopAllConnections() async {
    await nearbyCross.stopAllConnections();
  }

  Connector();
}
