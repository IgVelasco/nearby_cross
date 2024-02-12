import 'package:flutter/material.dart';
import 'package:nearby_cross_example/viewmodels/discoverer_viewmodel.dart';

class MainViewModel with ChangeNotifier {
  String? _username;
  bool advertiserMode = true;
  String get mode => advertiserMode ? "Advertiser" : "Discoverer";

  MainViewModel();

  void toggleAdvertiserMode() {
    advertiserMode = !advertiserMode;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  String get username => _username ?? "";
}
