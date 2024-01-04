import 'package:nearby_cross/models/connector_model.dart';

class Discoverer extends Connector {
  Future<void> startDiscovery(String serviceId, String? username) async {
    await nearbyCross.startDiscovery(serviceId, username);
  }
}
