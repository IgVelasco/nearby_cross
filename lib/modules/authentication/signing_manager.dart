import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto_keys/crypto_keys.dart';
// ignore: implementation_imports
import 'package:crypto_keys/src/impl.dart';
import 'package:logger/logger.dart';
import 'package:jwk/jwk.dart';
import 'package:nearby_cross/helpers/bytes_utils.dart';

class SigningManager {
  Logger logger = Logger();
  final selectedAlgorithm = algorithms.signing.ecdsa.sha256;
  final selectedCurve = curves.p256;
  late KeyPair? keyPair;
  late EcPrivateKeyImpl? privateKey;
  late EcPublicKeyImpl? publicKey;
  late Signer<PrivateKey>? signer;
  late Verifier<PublicKey>? verifier;
  bool initialized = false;

  /// Generates a new key pair (public and secret) that will authenticate this device
  SigningManager.initialize() {
    keyPair = KeyPair.generateEc(selectedCurve);
    privateKey = keyPair!.privateKey as EcPrivateKeyImpl;
    publicKey = keyPair!.publicKey as EcPublicKeyImpl;
    signer = privateKey!.createSigner(selectedAlgorithm);
    verifier = publicKey!.createVerifier(selectedAlgorithm);
    initialized = true;
  }

  /// Useful for loading a public key and a verifier for a third-party device
  /// [RFC-7517](https://datatracker.ietf.org/doc/html/rfc7517)
  /// [RFC example](https://datatracker.ietf.org/doc/html/rfc7517#section-3)
  SigningManager.initializeFromJwk(Map<String, dynamic> jwk) {
    keyPair = KeyPair.fromJwk(jwk);
    publicKey = keyPair!.publicKey as EcPublicKeyImpl?;
    if (publicKey != null) {
      verifier = publicKey!.createVerifier(selectedAlgorithm);
    } else {
      verifier = null;
    }

    privateKey = keyPair!.privateKey as EcPrivateKeyImpl?;
    if (privateKey != null) {
      signer = privateKey!.createSigner(selectedAlgorithm);
    } else {
      signer = null;
    }

    initialized = true;
  }

  /// Converts only the public key to JWK format
  /// [RFC-7517](https://datatracker.ietf.org/doc/html/rfc7517)
  /// [RFC example](https://datatracker.ietf.org/doc/html/rfc7517#section-3)
  String? convertPublicToJwk() {
    if (!initialized) return null;
    var jsonPublic = {
      "x": Jwk.base64UriEncode(BytesUtils.writeBigInt(publicKey!.xCoordinate)),
      "y": Jwk.base64UriEncode(BytesUtils.writeBigInt(publicKey!.yCoordinate)),
      "kty": "EC",
      "crv": "P-256"
    };
    return json.encode(jsonPublic);
  }

  /// Converts key pair to JWK format
  /// [RFC-7517](https://datatracker.ietf.org/doc/html/rfc7517)
  /// [RFC example](https://datatracker.ietf.org/doc/html/rfc7517#appendix-A.2)
  String? convertToJwk() {
    if (!initialized) return null;
    var jsonKeyPair = {
      "x": Jwk.base64UriEncode(BytesUtils.writeBigInt(publicKey!.xCoordinate)),
      "y": Jwk.base64UriEncode(BytesUtils.writeBigInt(publicKey!.yCoordinate)),
      "d": Jwk.base64UriEncode(
          BytesUtils.writeBigInt(privateKey!.eccPrivateKey)),
      "kty": "EC",
      "crv": "P-256"
    };
    return json.encode(jsonKeyPair);
  }

  /// Signs a message with the private key (signer)
  Signature? signMessage(Uint8List messageBytes) {
    if (!initialized) return null;
    return signer!.sign(messageBytes);
  }

  /// Verifies the authenticity of a message with a given signature (public key)
  bool verifyMessage(Uint8List messageBytes, Uint8List signature) {
    if (verifier == null) {
      return false;
    }

    return verifier!.verify(messageBytes, Signature(signature));
  }

  Uint8List getSignatureBytes(Uint8List bytesToSign) {
    var signature = signMessage(bytesToSign);
    return signature == null ? Uint8List(0) : signature.data;
  }
}
