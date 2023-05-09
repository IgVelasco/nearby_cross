import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nearby_cross_platform_interface.dart';

/// An implementation of [NearbyCrossPlatform] that uses method channels.
class MethodChannelNearbyCross extends NearbyCrossPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nearby_cross');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
