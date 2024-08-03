import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/modules/authentication/signing_manager.dart';

abstract class AuthenticationManager {
  /// SiginigManager instance.
  /// It will be used to sign messages before sending it to the connected peer
  late SigningManager signingManager;

  /// Identifier for this device (eg: uuid)
  late String identifier;

  /// Initializer function for this class. It will be executed when ConnectionsManager
  /// is initialized.
  /// Use this to set-up your authentication flow, like setting up the signingManager instance.
  void initialize();

  /// Signs NearbyMessage using signingManager instance
  void sign(NearbyMessage message) {
    message.signMessage(signingManager);
  }

  /// Starts handshake protocol.
  /// This will be executed every new device connection
  void startHandshake(Device device);

  /// Process a handshake message
  /// This will be executed when a NearbyMessageType.handshake message is received
  void processHandshake(Device device, NearbyMessage message);

  /// Sets identifier
  void setIdentifier(String newId);
}
