enum NearbyCrossMethods {
  onEndpointFound,
  connectionInitiated,
  successfulConnection,
  connectionRejected,
  payloadReceived,
  endpointDisconnected,
  onEndpointLost;

  String getString() {
    switch (this) {
      case NearbyCrossMethods.onEndpointFound:
        return 'onEndpointFound';
      case NearbyCrossMethods.onEndpointLost:
        return 'onEndpointLost';
      case NearbyCrossMethods.connectionInitiated:
        return 'connectionInitiated';
      case NearbyCrossMethods.successfulConnection:
        return 'successfulConnection';
      case NearbyCrossMethods.connectionRejected:
        return 'connectionRejected';
      case NearbyCrossMethods.payloadReceived:
        return 'payloadReceived';
      case NearbyCrossMethods.endpointDisconnected:
        return 'endpointDisconnected';
    }
  }
}
