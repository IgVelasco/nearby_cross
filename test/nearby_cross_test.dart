import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_cross/nearby_cross_platform_interface.dart';
import 'package:nearby_cross/nearby_cross_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// TODO: Proper testing
abstract class MockNearbyCrossPlatform
    with MockPlatformInterfaceMixin
    implements NearbyCrossPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final NearbyCrossPlatform initialPlatform = NearbyCrossPlatform.instance;

  test('$MethodChannelNearbyCross is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNearbyCross>());
  });
}
