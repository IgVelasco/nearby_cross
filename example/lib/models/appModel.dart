import 'package:flutter/foundation.dart';

class AppModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  bool _isDiscovering = false;

  bool get isDiscovering => _isDiscovering;

  void startDiscovery() {
    _isDiscovering = true;
    notifyListeners();
  }

  void stopDiscovery() {
    _isDiscovering = false;
    notifyListeners();
  }
}
