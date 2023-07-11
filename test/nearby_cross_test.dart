import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_cross/nearby_cross.dart';
import 'package:nearby_cross/nearby_cross_platform_interface.dart';
import 'package:nearby_cross/nearby_cross_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// TODO: check how to test this thing
class MockNearbyCrossPlatform
    with MockPlatformInterfaceMixin /* implements NearbyCrossPlatform */ {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NearbyCrossPlatform initialPlatform = NearbyCrossPlatform.instance;

  test('$MethodChannelNearbyCross is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNearbyCross>());
  });

  test('getPlatformVersion', () async {
    NearbyCross nearbyCrossPlugin = NearbyCross();
    MockNearbyCrossPlatform fakePlatform = MockNearbyCrossPlatform();
    // NearbyCrossPlatform.instance = fakePlatform;

    expect(await nearbyCrossPlugin.getPlatformVersion(), '42');
  });
}
