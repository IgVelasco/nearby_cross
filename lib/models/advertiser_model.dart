import 'package:nearby_cross/models/connector_model.dart';

/// Class that represent the Advertiser instance of NearbyCross plugin.
class Advertiser extends Connector {
  static Advertiser? _singleton;
  bool isAdvertising = false;

  /// Implements singleton pattern
  factory Advertiser() {
    _singleton ??= Advertiser._internal();

    return _singleton!;
  }

  /// Service to start advertising using NearbyCross plugin
  Future<void> advertise(String? username,
      {bool manualAcceptConnections = false}) async {
    await nearbyCross.advertise(serviceId, username, manualAcceptConnections);
    isAdvertising = true;
    this.username = username;
  }

  Future<void> stopAdvertising() async {
    await nearbyCross.disconnect(serviceId);
    isAdvertising = false;
  }

  Advertiser._internal() : super();
}
