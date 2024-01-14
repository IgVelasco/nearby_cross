import 'package:nearby_cross/models/connector_model.dart';

class Advertiser extends Connector {
  static Advertiser? _singleton;

  factory Advertiser() {
    _singleton ??= Advertiser._internal();

    return _singleton!;
  }

  Future<void> advertise(String? username) async {
    await nearbyCross.advertise(serviceId, username);
  }

  Advertiser._internal() : super();
}
