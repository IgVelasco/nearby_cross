import 'package:nearby_cross/models/connector_model.dart';

class Advertiser extends Connector {
  Future<void> advertise(String serviceId, String? username) async {
    await nearbyCross.advertise(serviceId, username);
  }
}
