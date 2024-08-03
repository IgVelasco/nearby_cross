import 'package:logger/logger.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross/models/message_model.dart';
import 'package:nearby_cross/modules/authentication/authentication_manager.dart';
import 'package:nearby_cross/modules/authentication/signing_manager.dart';
import 'package:uuid/uuid.dart';

class ExampleAuthenticationManager extends AuthenticationManager {
  Logger logger = Logger();

  Map<String, String> devices = {
    'DOCENTE': "f664861e-051d-4d91-ade2-0e0db02fc6e5",
    'ALUMNO': "959c4b53-1447-48c6-a7a2-6549452b08ab",
  };

  Map<String, Map<String, String>> keyPairs = {
    'f664861e-051d-4d91-ade2-0e0db02fc6e5': {
      "kty": "EC",
      "d": "jsqxSEUr_M2yLSRkWxRc8pZE_2NaDjzug80CR9RLEgo",
      "use": "sig",
      "crv": "P-256",
      "kid": "KR5eFrdErJu4--YNGiGA55SOgWTbqsf4G8QEiRb6VzA",
      "x": "UhFPo-Jk-tc9Z69F3gvHCfB-CakFj5RCtE-Q0hVoAS8",
      "y": "cdDaTeJ6oQpZhcM150XSNLzy3Bm4qrZrFp3E-hvfFHU",
      "alg": "ES256"
    },
    '959c4b53-1447-48c6-a7a2-6549452b08ab': {
      "kty": "EC",
      "d": "DxEvWYHOEHhbzfT-TNl_xqpPx6t4E_0QNm6G4dA0tz4",
      "use": "sig",
      "crv": "P-256",
      "kid": "e4gcoRrc5N2hQX40cOrNpG2VL0mOtpdvwpP59kAEPPo",
      "x": "8cRW5GTkyzSMqjgtI70soq8PWvMkBllmIZhhfFdt7WQ",
      "y": "oBxxIuAspl82mVAAAFsRsR_72SLNAG_2n8CmwMBTzTA",
      "alg": "ES256"
    },
  };

  @override
  void setIdentifier(String newId) {
    identifier = newId;
  }

  @override
  void initialize() {
    const profile = String.fromEnvironment("PROFILE", defaultValue: 'DOCENTE');
    var identifier = devices[profile] ?? const Uuid().v4();
    var keyPairJwk = keyPairs[identifier];
    signingManager = SigningManager.initializeFromJwk(keyPairJwk!);
  }

  @override
  void startHandshake(Device device) {
    // If not in experimental mode, the handshake message includes the identifier for this
    // device, and the peer device must validate the signature of this message using a public
    // key obtained from a trustworthy source.
    var message = NearbyMessage.handshakeMessage(identifier);
    message.signMessage(signingManager);
    device.sendMessage(message, dropMessage: true);
  }

  @override
  void processHandshake(Device device, NearbyMessage message) {
    // If not in experimental mode, this handshake received message contains the identifier
    // for the peer device. We must obtain its public key from a trustworthy source using this identifier.
    var peerInfo = keyPairs[BytesUtils.getString(message.message)];
    logger.i(peerInfo);
    var verifier = SigningManager.initializeFromJwk(peerInfo!);
    device.addVerifier(verifier);
    device.setAuthManager(this);

    var validSignature =
        verifier.verifyMessage(message.message, message.signature);
    device.setIsAuthenticated(validSignature);

    if (validSignature) {
      logger.d("Received handshake is authenticated!");
    } else {
      logger.e("Received handshake is not from an authenticated third-paty!");
    }
  }

  @override
  void sign(NearbyMessage message) {
    message.signMessage(signingManager);
  }
}
