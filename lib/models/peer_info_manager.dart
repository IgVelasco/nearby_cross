class PeerIdentifications {
  Map<String, Map<String, String>> peerIdentifications = {};
  PeerIdentifications();

  void setPeerIdentification(String identifier, Map<String, String> publicKey) {
    peerIdentifications[identifier] = publicKey;
  }

  Map<String, String>? getPeerIdentification(String identifier) {
    return peerIdentifications[identifier];
  }
}
