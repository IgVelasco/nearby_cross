import 'package:flutter/foundation.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/discoverer_model.dart';

class DiscovererViewModel with ChangeNotifier {
  Discoverer discoverer = Discoverer();

  DiscovererViewModel() {
    discoverer.setOnDeviceFoundCallback(_commonCallback);
    discoverer.setCallbackConnectionInitiated(_commonCallback);
    discoverer.setCallbackSuccessfulConnection(_commonCallback);
    discoverer.setCallbackReceivedMessage(_commonCallback);
  }

  void _commonCallback(Device device) {
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

  Future<void> connect(String endpointId) {
    return discoverer.connect(endpointId);
  }
}
