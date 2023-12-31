import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef Item = HashMap<String, String>;

class AppModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  bool _isDiscovering = false;
  bool _connected = false;

  String _username = 'default username';
  Item _connectedAdvertiser = HashMap();

  final List<Item> _advertisers = [
    HashMap.from({"username": "Ric", "endpointId": "aX09"}),
    HashMap.from({"username": "NICS", "endpointId": "B2FF"}),
  ];

  bool get isDiscovering => _isDiscovering;
  bool get connected => _connected;
  Item get connectedAdvertiser => _connectedAdvertiser;
  String get username => _username;

  UnmodifiableListView<Item> get items => UnmodifiableListView(_advertisers);

  int get totalAmount => _advertisers.length;

  void add(Item item) {
    _advertisers.add(item);
    notifyListeners();
  }

  void removeAll() {
    _advertisers.clear();
    notifyListeners();
  }

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void connectToAdvertiser(Item item) {
    print(
        "Connecting to advertiser ${item["endpointId"]} name ${item["username"]}");
    _connectedAdvertiser = item;
    _connected = true;
    // _username = newUsername;
    notifyListeners();
  }

  void disconnect() {
    _connectedAdvertiser = HashMap();
    _connected = false;
    print("Disconnected!");
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
