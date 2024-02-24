import 'package:nearby_cross/models/advertiser_model.dart';
import 'package:nearby_cross/models/connections_manager_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:logger/logger.dart';

import '../helpers/permission_manager.dart';

class Connector {
  var logger = Logger();
  String? platformVersion;
  String? username;
  NearbyCross nearbyCross = NearbyCross();
  ConnectionsManager connectionsManager = ConnectionsManager();
  bool get isConnected => connectionsManager.connectedDevices.isNotEmpty;

  String serviceId = 'com.example.nearbyCrossExample';

  Future<void> requestPermissions() async {
    await PermissionManager.requestPermissions();
  }

  Future<String?> getPlatformVersion() async {
    platformVersion = await nearbyCross.getPlatformVersion();
    return platformVersion;
  }

  Future<void> connect(String endpointId) async {
    await nearbyCross.connect(endpointId);
  }

  Future<void> disconnectFrom(String endpointId) async {
    await nearbyCross.disconnectFrom(endpointId);
  }

  Future<void> stopAllConnections() async {
    await nearbyCross.stopAllConnections();
  }

  Connector();
}
