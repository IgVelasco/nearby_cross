enum NearbyCrossMethods {
  onEndpointFound,
  connectionInitiated,
  successfulConnection,
  payloadReceived;

  String getString() {
    switch (this) {
      case NearbyCrossMethods.onEndpointFound:
        return 'onEndpointFound';
      case NearbyCrossMethods.connectionInitiated:
        return 'connectionInitiated';
      case NearbyCrossMethods.successfulConnection:
        return 'successfulConnection';
      case NearbyCrossMethods.payloadReceived:
        return 'payloadReceived';
    }
  }
}
