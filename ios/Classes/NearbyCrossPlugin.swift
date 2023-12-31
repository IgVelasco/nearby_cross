import Flutter
import UIKit

public class NearbyCrossPlugin: NSObject, FlutterPlugin {
  let channel: FlutterMethodChannel
  var advertiser: NearbyConnectAdvertiser?
  var discoverer: NearbyConnectDiscoverer?
  var advertising: Bool = false
  var discovering: Bool = false
  var listOfNearbyDevices: [String] = .init()
  var listOfConnectedDevices: [String] = .init()

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nearby_cross", binaryMessenger: registrar.messenger())
    let instance = NearbyCrossPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "generateColor":
      let randomColor = generateColor()
      result(randomColor)
    case "startAdvertising":
      advertiser = NearbyConnectAdvertiser(channel, self)
      if let advertiser_instance = advertiser?.advertiser {
        advertiser_instance.startAdvertising(using: "My Device".data(using: .utf8)!)
        advertising = true
        result("Done")
      } else {
        result("Failed to start advertising")
      }
    case "startDiscovery":
      if(discoverer == nil){
        discoverer = NearbyConnectDiscoverer(channel, self)
      }
      if let discoverer_instance = discoverer?.discoverer {
        discoverer_instance.startDiscovery()
        discovering = true
        result("Done")
      } else {
        result("Failed to start discovery")
      }
    case "broadcastData":
        if let data = call.arguments as? String {
            sendData(receivedString: data)
            result("Done")
        } else {
            print("No data sent")
            result("Failed") // or any other appropriate result value
        }
    case "disconnect":
      // TODO: something wrong, when disconnecting and connecting on advertise endpoint doesnt change
      // I believe ios mantains endpointId
      if discovering {
        discoverer?.discoverer?.stopDiscovery()
        discovering = false
      }
      if advertising {
        advertiser?.advertiser?.stopAdvertising()
        advertising = false
      }
      result("Done")
    default:
      result("Not implemented")
    }
  }

  func announceDiscoveredService(_ endpointId: EndpointID) {
    channel.invokeMethod("onEndpointFound", arguments: endpointId)
  }

  private func generateColor() -> [Int] {
    return [0, 0, 0].map { _ -> Int in
      Int.random(in: 0 ... 255)
    }
  }
    
    
    
    
    func sendData( receivedString: String) {
//        TODO: make connection manager getter
        if let bytesPayload = receivedString.data(using: .utf8) {
            // Use the data here
            // The 'data' variable now contains the bytes representing the string in UTF-8 encoding
            if let discoverer_instance = discoverer?.discoverer {
                discoverer_instance.connectionManager.send(bytesPayload, to: listOfConnectedDevices)
            } else if let advertiser_instance = advertiser?.advertiser {
                advertiser_instance.connectionManager.send(bytesPayload, to: listOfConnectedDevices)
            } else {
                print("No instance for sending available")
            }
        } else {
            print("Error parsing string to bytes")
        }
    }
}

class NearbyConnectAdvertiser {
  let connectionManager: ConnectionManager
  var channel: FlutterMethodChannel
  var advertiser: Advertiser? = Optional.none
  var nearbyConnector: NearbyCrossPlugin

  init(_ chn: FlutterMethodChannel, _ nearbyConnector: NearbyCrossPlugin) {
    channel = chn
    self.nearbyConnector = nearbyConnector
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
  var nearbyConnector: NearbyCrossPlugin

  init(_ chn: FlutterMethodChannel, _ nearbyConnector: NearbyCrossPlugin) {
    channel = chn
    self.nearbyConnector = nearbyConnector
    connectionManager = ConnectionManager(serviceID: "com.example.nearbyCrossExample", strategy: .star)
    connectionManager.delegate = self

    discoverer = Discoverer(connectionManager: connectionManager)
    discoverer?.delegate = self
    discoverer?.startDiscovery()
  }
}

extension NearbyConnectDiscoverer: DiscovererDelegate {
  func discoverer(
    _ discoverer: Discoverer, didFind endpointID: EndpointID, with _: Data
  ) {
    // An endpoint was found.
    nearbyConnector.listOfNearbyDevices.append(String(endpointID))
    print(String(endpointID))
    channel.invokeMethod("onEndpointFound", arguments: endpointID)
    discoverer.requestConnection(to: endpointID, using: "My Device".data(using: .utf8)!)
  }

  func discoverer(_: Discoverer, didLose endpointId: EndpointID) {
    // A previously discovered endpoint has gone away.
    nearbyConnector.listOfNearbyDevices.removeAll { $0 == String(endpointId) }
    print(String(endpointId))
  }
}

extension NearbyConnectAdvertiser: AdvertiserDelegate {
  func advertiser(
    _: Advertiser, didReceiveConnectionRequestFrom endpointId: EndpointID,
    with _: Data, connectionRequestHandler: @escaping (Bool) -> Void
  ) {
    // Accept or reject any incoming connection requests. The connection will still need to
    // be verified in the connection manager delegate.
    nearbyConnector.listOfConnectedDevices.append(String(endpointId))
    connectionRequestHandler(true)
  }
}

extension NearbyConnectAdvertiser: ConnectionManagerDelegate {
  func connectionManager(
    _: ConnectionManager, didReceive _: String,
    from _: EndpointID, verificationHandler: @escaping (Bool) -> Void
  ) {
    // Optionally show the user the verification code. Your app should call this handler
    // with a value of `true` if the nearby endpoint should be trusted, or `false`
    // otherwise.
    verificationHandler(true)
  }

  func connectionManager(
    _: ConnectionManager, didReceive data: Data, withID _: PayloadID,
    from _: EndpointID
  ) {
    if let receivedString = String(data: data, encoding: .utf8) {
      // Use the receivedString here
      channel.invokeMethod("onEndpointFound", arguments: receivedString)
      print(receivedString)
    } else {
      // Failed to convert the data to a string using UTF-8 encoding
      print("Failed to convert data to string.")
    }

    // Handle the received data from the nearby endpoint.
  }

  func connectionManager(
    _: ConnectionManager, didReceive _: InputStream,
    withID _: PayloadID, from _: EndpointID,
    cancellationToken _: CancellationToken
  ) {
    // Handle the received byte stream from the nearby endpoint.
  }

  func connectionManager(
    _: ConnectionManager, didStartReceivingResourceWithID _: PayloadID,
    from _: EndpointID, at _: URL, withName _: String,
    cancellationToken _: CancellationToken
  ) {
    // Handle the start of receiving a resource from the nearby endpoint.
  }

  func connectionManager(
    _: ConnectionManager, didReceiveTransferUpdate _: TransferUpdate,
    from _: EndpointID, forPayload _: PayloadID
  ) {
    // Handle the transfer update for an incoming or outgoing transfer.
  }

  func connectionManager(
    _: ConnectionManager, didChangeTo connectionState: ConnectionState,
    for endpointID: EndpointID
  ) {
    switch connectionState {
    case .connecting:
      // Handle connecting state
      break
    case .connected:
      // Handle connected state
      break
    case .disconnected:
      // Handle disconnected state
      // Perform actions when the connection is disconnected
      nearbyConnector.listOfConnectedDevices.removeAll { $0 == String(endpointID) }
      print("Endpoint disconnected:", endpointID)
    // Your code here
    case .rejected:
      // Handle rejected state
      break
    }
  }
}

extension NearbyConnectDiscoverer: ConnectionManagerDelegate {
  func connectionManager(
    _: ConnectionManager, didReceive _: String,
    from endpointId: EndpointID, verificationHandler: @escaping (Bool) -> Void
  ) {
      nearbyConnector.listOfConnectedDevices.append(String(endpointId))
      verificationHandler(true)
  }

  func connectionManager(
    _: ConnectionManager, didReceive data: Data, withID _: PayloadID,
    from _: EndpointID
  ) {
    // Handle the received data from the nearby endpoint.
    if let receivedString = String(data: data, encoding: .utf8) {
      // Use the receivedString here
      channel.invokeMethod("onEndpointFound", arguments: receivedString)
      print(receivedString)
    } else {
      // Failed to convert the data to a string using UTF-8 encoding
      print("Failed to convert data to string.")
    }
  }

  func connectionManager(
    _: ConnectionManager, didReceive _: InputStream,
    withID _: PayloadID, from _: EndpointID,
    cancellationToken _: CancellationToken
  ) {
    // Handle the received byte stream from the nearby endpoint.
  }

  func connectionManager(
    _: ConnectionManager, didStartReceivingResourceWithID _: PayloadID,
    from _: EndpointID, at _: URL, withName _: String,
    cancellationToken _: CancellationToken
  ) {
    // Handle the start of receiving a resource from the nearby endpoint.
  }

  func connectionManager(
    _: ConnectionManager, didReceiveTransferUpdate _: TransferUpdate,
    from _: EndpointID, forPayload _: PayloadID
  ) {
    // Handle the transfer update for an incoming or outgoing transfer.
  }

  func connectionManager(
    _: ConnectionManager, didChangeTo _: ConnectionState,
    for _: EndpointID
  ) {
    // Handle the change in connection status to a nearby endpoint.
  }
}
