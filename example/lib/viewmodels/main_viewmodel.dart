import 'package:flutter/material.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';

class MainViewModel with ChangeNotifier {
  String? _username;
  bool advertiserMode = true;
  String get mode => advertiserMode ? "Advertiser" : "Discoverer";
  NearbyStrategies strategy = NearbyStrategies.star;

  MainViewModel();

  void toggleAdvertiserMode() {
    advertiserMode = !advertiserMode;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setStrategy(NearbyStrategies strategy) {
    this.strategy = strategy;
    notifyListeners();
  }

  String get username => _username ?? "";
}
