import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef Item = HashMap<String, String>;

class AppModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  bool _isDiscovering = false;
  String _username = 'default username';
  final List<Item> _items = [
    HashMap.from({"name": "Ric"}),
    HashMap.from({"name": "NICS"}),
  ];

  bool get isDiscovering => _isDiscovering;
  String get username => _username;

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  int get totalAmount => _items.length;

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void startDiscovery() {
    _isDiscovering = true;
    print("Starting discovery!");
    notifyListeners();
  }

  void stopDiscovery() {
    _isDiscovering = false;
    print("Stopping discovery!");
    notifyListeners();
  }
}
