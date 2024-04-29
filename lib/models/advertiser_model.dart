import 'package:nearby_cross/constants/nearby_constraints.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross/errors/device_info_too_large.error.dart';
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
  Future<void> advertise(
      {bool manualAcceptConnections = false,
      NearbyStrategies strategy = NearbyStrategies.star}) async {
    if (deviceInfo.length > NearbyConstraints.deviceInfoMaxBytes) {
      throw const DeviceInfoTooLarge(NearbyConstraints.deviceInfoMaxBytes);
    }
    await nearbyCross.advertise(
        serviceId, deviceInfo, manualAcceptConnections, strategy);
    isAdvertising = true;
  }

  Future<void> stopAdvertising() async {
    await nearbyCross.stopAdvertising();
    isAdvertising = false;
  }

  Advertiser._internal() : super();
}
