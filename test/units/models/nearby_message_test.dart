import 'package:nearby_cross/models/message_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Nearby Message string', () {
    var nearbyMessage = NearbyMessage.fromString("Test");
    expect(nearbyMessage.toString(), "Test");
  });
}
