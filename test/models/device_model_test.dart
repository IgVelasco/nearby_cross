import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:mockito/mockito.dart';
import 'package:nearby_cross/nearby_cross.dart';

class MockNearby extends Mock implements NearbyCross {}

void main() {
  test('Check messages on device', () {
    var device = Device.fromConnection(MockNearby(), "123", "abc");
    device.addMessage(NearbyMessage.fromString("abc"));
    expect(device.getAllMessages().first.toString(), "abc");
  });
}
