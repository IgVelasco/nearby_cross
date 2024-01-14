import 'package:flutter/foundation.dart';
import 'package:nearby_cross/models/advertiser_model.dart';
import 'package:nearby_cross/models/device_model.dart';

class AdvertiserViewModel with ChangeNotifier {
  Advertiser advertiser = Advertiser();

  AdvertiserViewModel() {
    advertiser.setCallbackConnectionInitiated(_commonCallback);
    advertiser.setCallbackSuccessfulConnection(_commonCallback);
    advertiser.setCallbackReceivedMessage(_commonCallback);
  }

  void _commonCallback(Device device) {
    notifyListeners();
  }

  void findPlatformVersion() {
    advertiser.getPlatformVersion().then((_) {
      notifyListeners();
    });
  }

  String? getPlatformVersion() {
    return advertiser.platformVersion;
  }

  Future<void> requestPermissions() {
    return advertiser.requestPermissions();
  }

  Future<void> startAdvertising(String? deviceName) {
    return advertiser.advertise(deviceName);
  }

  Future<void> disconnect() {
    return advertiser.disconnect();
  }
}
