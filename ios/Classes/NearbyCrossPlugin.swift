import Flutter
import UIKit


public class NearbyCrossPlugin: NSObject, FlutterPlugin {
  let channel: FlutterMethodChannel
    var advertiser: NearbyConnectAdvertiser?
    var discoverer: NearbyConnectDiscoverer?
    var advertising: Bool = false
    var discovering: Bool = false



  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nearby_cross", binaryMessenger: registrar.messenger())
    let instance = NearbyCrossPlugin(channel: channel)
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
      advertiser = NearbyConnectAdvertiser();
      advertising = true;
      result("Done");
      break;
    case "startDiscovery":
      discoverer = NearbyConnectDiscoverer(channel);
      discovering = true
      result("Done")
      break;
    case "disconnect":
        // TODO: something wrong, when disconnecting and connecting on advertise endpoint doesnt change
        // I believe ios mantains endpointId
        if(discovering){
            discoverer?.discoverer?.stopDiscovery()
            discovering = false
        }
        if(advertising){
            advertiser?.advertiser?.stopAdvertising()
            advertising = false
        }
        result("Done")
        break;
    default:
      result("Not implemented");
      break;
    }
  }

    func announceDiscoveredService(_ endpointId: EndpointID) {
        channel.invokeMethod("onEndpointFound", arguments: endpointId)
    }

  private func generateColor() -> [Int] {
    return [0,0,0].map { (v) -> Int in
      return Int.random(in: 0...255)}
  }
}

class NearbyConnectAdvertiser {
    let connectionManager: ConnectionManager
    var advertiser: Advertiser? = Optional.none
    
    init() {
        connectionManager = ConnectionManager(serviceID: "com.example.nearbyCrossExample", strategy: .star)
        connectionManager.delegate = self
        
        advertiser = Advertiser(connectionManager: connectionManager)
        advertiser?.delegate = self
        advertiser?.startAdvertising(using: "My Device".data(using: .utf8)!)
    }
}

class NearbyConnectDiscoverer {
    let connectionManager: ConnectionManager
    var discoverer: Discoverer? = Optional.none
    var channel: FlutterMethodChannel
    var listOfNearbyDevices: [String] = [String]()
    
    init(_ chn: FlutterMethodChannel) {
        channel = chn
        connectionManager = ConnectionManager(serviceID: "com.example.nearbyCrossExample", strategy: .star)
        connectionManager.delegate = self
        
        discoverer = Discoverer(connectionManager: connectionManager)
        discoverer?.delegate = self
        discoverer?.startDiscovery()
    }
    
}

extension NearbyConnectDiscoverer: DiscovererDelegate {
  func discoverer(
    _ discoverer: Discoverer, didFind endpointID: EndpointID, with context: Data) {
    // An endpoint was found.
        listOfNearbyDevices.append(String(endpointID))
        print(String(endpointID))
        channel.invokeMethod("onEndpointFound", arguments: endpointID)
  }

  func discoverer(_ discoverer: Discoverer, didLose endpointID: EndpointID) {
    // A previously discovered endpoint has gone away.
      print(String(endpointID))
  }
}

extension NearbyConnectAdvertiser: AdvertiserDelegate {
  func advertiser(
    _ advertiser: Advertiser, didReceiveConnectionRequestFrom endpointID: EndpointID,
    with context: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
    // Accept or reject any incoming connection requests. The connection will still need to
    // be verified in the connection manager delegate.
    connectionRequestHandler(true)
  }
}

extension NearbyConnectAdvertiser: ConnectionManagerDelegate {
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

extension NearbyConnectDiscoverer: ConnectionManagerDelegate {
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

