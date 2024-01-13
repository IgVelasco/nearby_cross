import 'package:flutter/foundation.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';

class DiscovererViewModel with ChangeNotifier {
  Discoverer discoverer = Discoverer();

  DiscovererViewModel() {
    discoverer.setOnDeviceFoundCallback(_callbackDeviceFound);
  }

  void _callbackDeviceFound(Device device) {
    notifyListeners();
  }

  void findPlatformVersion() {
    discoverer.getPlatformVersion().then((_) {
      notifyListeners();
    });
  }

  String? getPlatformVersion() {
    return discoverer.platformVersion;
  }

  Future<void> requestPermissions() {
    return discoverer.requestPermissions();
  }

  Future<void> startDiscovering(String? deviceName) {
    return discoverer.startDiscovery(deviceName);
  }

  List<Device> getDiscoveredDevices() {
    return discoverer.listOfDiscoveredDevices.toList();
  }

  Future<void> disconnect() {
    return discoverer.disconnect();
  }

  Future<void> sendData(String data) {
    return discoverer.sendData(data);
  }

  Future<void> connect(String endpointId) {
    return discoverer.connect(endpointId);
  }
}
