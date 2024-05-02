import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/modules/authentication/signing_manager.dart';

abstract class AuthenticationManager {
  late SigningManager signingManager;

  void sign(NearbyMessage message);

  void startHandshake(Device device);
  void processHandshake(Device device, NearbyMessage message);

  void initialize();

  void setIdentifier(String newId);
}
