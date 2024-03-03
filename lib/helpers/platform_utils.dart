import 'dart:io';
import 'package:device_info/device_info.dart';

Future<String> getDeviceName() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.name ?? 'Unknown';
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model ?? 'Unknown';
  } else {
    return 'Unknown';
  }
}
