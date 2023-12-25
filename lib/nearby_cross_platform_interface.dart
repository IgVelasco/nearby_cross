import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nearby_cross_method_channel.dart';

abstract class NearbyCrossPlatform extends PlatformInterface {
  /// Constructs a NearbyCrossPlatform.
  NearbyCrossPlatform() : super(token: _token);

  static final Object _token = Object();

  static NearbyCrossPlatform _instance = MethodChannelNearbyCross();

  /// The default instance of [NearbyCrossPlatform] to use.
  ///
  /// Defaults to [MethodChannelNearbyCross].
  static NearbyCrossPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NearbyCrossPlatform] when
  /// they register themselves.
  static set instance(NearbyCrossPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> startDiscovery(String serviceId, String? username);
  Future<void> advertise(String serviceId, String? username);
  Future<void> disconnect(String serviceId);
  Future<void> sendData(String data);
  Future<void> sendDataUsername(String username,String data);
}
