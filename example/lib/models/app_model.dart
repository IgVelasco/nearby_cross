import 'package:flutter/foundation.dart';

class AppModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  bool _isDiscovering = false;
  String _username = 'default username';

  bool get isDiscovering => _isDiscovering;
  String get username => _username;

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void startDiscovery() {
    _isDiscovering = true;
    notifyListeners();
  }

  void stopDiscovery() {
    _isDiscovering = false;
    notifyListeners();
  }
}
