import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    final permissions = [
      Permission.location,
      Permission.bluetooth,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ];

    final permissionStatuses = await permissions.request();

    return permissionStatuses;
  }
}
