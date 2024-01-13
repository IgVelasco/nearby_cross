import 'package:flutter/foundation.dart';
import 'package:nearby_cross/models/advertiser_model.dart';

class AdvertiserViewModel with ChangeNotifier {
  Advertiser advertiser = Advertiser();

  void findPlatformVersion() {
    advertiser.getPlatformVersion().then((_) {
      notifyListeners();
    });
  }

  String? getPlatformVersion() {
    return advertiser.platformVersion;
  }
}
