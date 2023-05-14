import Flutter
import UIKit


public class NearbyCrossPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nearby_cross", binaryMessenger: registrar.messenger())
    let instance = NearbyCrossPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      break;
    case "generateColor":
      let randomColor = generateColor();
      result(randomColor);
      break;
    case "startAdvertising":
      let nearbyConnect = NearbyConnect();
      let randomColor = generateColor();
      result(randomColor);
      break;
    default:
      result("Not implemented");
      break;
    }
  }

  private func generateColor() -> [Int] {
    return [0,0,0].map { (v) -> Int in
      return Int.random(in: 0...255)}
  }
}


class NearbyConnect {
  let connectionManager: ConnectionManager
  let advertiser: Advertiser

  init() {
    connectionManager = ConnectionManager(serviceID: "com.example.nearbyCrossExample", strategy: .star)
    advertiser = Advertiser(connectionManager: connectionManager)
    connectionManager.delegate = self
    advertiser.delegate = self

    advertiser.startAdvertising(using: "My Device".data(using: .utf8)!)
  }
}

extension NearbyConnect: AdvertiserDelegate {
  func advertiser(
    _ advertiser: Advertiser, didReceiveConnectionRequestFrom endpointID: EndpointID,
    with context: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
    // Accept or reject any incoming connection requests. The connection will still need to
    // be verified in the connection manager delegate.
    connectionRequestHandler(true)
  }
}

extension NearbyConnect: ConnectionManagerDelegate {
    func connectionManager(
        _ connectionManager: ConnectionManager, didReceive verificationCode: String,
        from endpointID: EndpointID, verificationHandler: @escaping (Bool) -> Void
    ) {
        verificationHandler(true)
    }

    func connectionManager(
        _ connectionManager: ConnectionManager, didReceive data: Data, withID payloadID: PayloadID,
        from endpointID: EndpointID
    ) {
        // Handle the received data from the nearby endpoint.
    }

    func connectionManager(
        _ connectionManager: ConnectionManager, didReceive stream: InputStream,
        withID payloadID: PayloadID, from endpointID: EndpointID,
        cancellationToken token: CancellationToken
    ) {
        // Handle the received byte stream from the nearby endpoint.
    }

    func connectionManager(
        _ connectionManager: ConnectionManager, didStartReceivingResourceWithID payloadID: PayloadID,
        from endpointID: EndpointID, at localURL: URL, withName name: String,
        cancellationToken token: CancellationToken
    ) {
        // Handle the start of receiving a resource from the nearby endpoint.
    }

    func connectionManager(
        _ connectionManager: ConnectionManager, didReceiveTransferUpdate update: TransferUpdate,
        from endpointID: EndpointID, forPayload payloadID: PayloadID
    ) {
        // Handle the transfer update for an incoming or outgoing transfer.
    }

    func connectionManager(
        _ connectionManager: ConnectionManager, didChangeTo state: ConnectionState,
        for endpointID: EndpointID
    ) {
        // Handle the change in connection status to a nearby endpoint.
    }
}

