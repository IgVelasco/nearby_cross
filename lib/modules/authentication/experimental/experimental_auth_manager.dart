import 'dart:convert';

import 'package:jwk/jwk.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/modules/authentication/authentication_manager.dart';
import 'package:nearby_cross/modules/authentication/signing_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperimentalAuthManager extends AuthenticationManager {
  Logger logger = Logger();
  String? identifier;

  @override
  void initialize() {
    // If not receiving a JWK for a Key Pair to use, look for it in the local storage
    // If not found, generate a random key pair and store it in Local Storage for future use
    SharedPreferences.getInstance().then((prefs) async {
      var jwk = prefs.getString('signing_manager_jwk');
      if (jwk != null) {
        logger.i("Found Keys JWK. Starting Signing Manager from old config");
        var decoded = json.decode(jwk);
        signingManager = SigningManager.initializeFromJwk(decoded);
      } else {
        logger.i(
            "Old JWK Config not found. Starting a new instance for signing session");
        signingManager = SigningManager.initialize();
        var encoded = signingManager.convertToJwk();
        await prefs.setString('signing_manager_jwk', encoded!);
      }
    });
  }

  @override
  void startHandshake(Device device) {
    // In experimental mode, the handshake message includes the public key to be used
    // for this device authentication
    var message =
        NearbyMessage.handshakeMessage(signingManager.convertPublicToJwk()!);
    device.sendMessage(message, dropMessage: true);
  }

  @override
  void processHandshake(Device device, NearbyMessage message) {
    // In experimental mode, this handshake received message contains the public key
    // of the peer device that is connecting
    var verifier = SigningManager.initializeFromJwk(
        Jwk.fromUtf8(message.message).toJson());
    device.addVerifier(verifier);
    device.setAuthManager(this);
    device.setIsAuthenticated(true);
  }

  @override
  void sign(NearbyMessage message) {
    message.signMessage(signingManager);
  }

  @override
  void setIdentifier(String newId) {
    identifier = newId;
  }
}
