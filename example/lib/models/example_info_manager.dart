import 'package:nearby_cross/models/peer_info_manager.dart';

/// This class is intended to be a replacement for a trustworthy source for users' Public Keys
/// In a more productive platform the users' public keys should be retrieved from a
/// trustworthy source such as a backend server
class ExampleInfoManager extends PeerIdentifications {
  static ExampleInfoManager? _singleton;
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

  factory ExampleInfoManager() {
    _singleton ??= ExampleInfoManager._internal();

    return _singleton!;
  }

  ExampleInfoManager._internal() {
    for (var id in devices.values) {
      setPeerIdentification(id, keyPairs[id]!);
    }
  }

  Map<String, String>? getDataForProfile(String profile) {
    var identifier = devices[profile];
    return keyPairs[identifier];
  }
}
