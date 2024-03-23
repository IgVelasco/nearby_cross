 //
 //  NCAdvertiser.swift
 //  nearby_cross
 //
 //  Created by Ignacio Velasco on 29/02/2024.
 //

 import Foundation

class ConnectionAttempt {
    var endpointId: String
    var endpointName: String
    var connectionRequestHandler: (Bool) -> Void
    
    init(endpointId: String, endpointName: String, connectionRequestHandler: @escaping (Bool) -> Void) {
        self.endpointId = endpointId
        self.endpointName = endpointName
        self.connectionRequestHandler = connectionRequestHandler
    }
    
    func handleConnection(result: Bool) {
        connectionRequestHandler(result)
    }
}


 class NCAdvertiser: Connector, AdvertiserDelegate {

     lazy var advertiser: Advertiser = {
         let ad = Advertiser(connectionManager: connectionManager)
         ad.delegate = self
         return ad
     }()
     var connectionAttempts: [ConnectionAttempt] = []
    
     init(serviceId: String,
          strategy: String,
          context: UIApplication,
          callbacks: AdvertiserCallbacks,
          userName: String = GeneralConstants.DEFAULT_USERNAME,
          manualAcceptConnections: Bool = false) {
          super.init(serviceId: serviceId,
                    strategy: strategy,
                    context: context,
                    callbacks: callbacks,
                    userName: userName,
                    manualAcceptConnections: manualAcceptConnections)
     }

     override func connectionManager(_ connectionManager: ConnectionManager, didChangeTo state: ConnectionState, for endpointID: EndpointID) {
         switch state {
             case .connecting:
                 // A connection to the remote endpoint is currently being established.
                 print("connecting")
             break;
             case .connected:
                // We're connected! Can now start sending and receiving data.
                print("connected")
                callbacks.onSuccessfulConnection(endpointId: endpointID)
             break;
             case .disconnected:
                // We've been disconnected from this endpoint. No more data can be sent or received.
                print("disconnected")
             break;
             case .rejected:
                // The connection was rejected by one or both sides.
                 print("rejected")
             callbacks.onRejectedConnection(endpointId: endpointID)
             break;
          }
     }

     func advertiser(_ advertiser: Advertiser, didReceiveConnectionRequestFrom endpointID: EndpointID, with context: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
         // Accept or reject any incoming connection requests. The connection will still need to
         // be verified in the connection manager delegate.
         let endpointName = String(decoding: context, as: UTF8.self)
         let connectionAttempt = ConnectionAttempt(
            endpointId: endpointID, endpointName: endpointName, connectionRequestHandler: connectionRequestHandler
         )
         connectionAttempts.append(connectionAttempt)

         if (!manualAcceptConnections) {
             connectionAttempt.handleConnection(result: true)
         }
         
         callbacks.onConnectionInitiated(endpointId: endpointID, endpointName: connectionAttempt.endpointName, alreadyAcceptedConnection: !manualAcceptConnections)
     }
    
     func startAdvertising() {
         advertiser.startAdvertising(using: userName)
     }
     
     func acceptConnection(endpointId: String) {
         guard let connectionAttemptIndex = connectionAttempts.firstIndex(where: {$0.endpointId == endpointId} ) else { return }
         connectionAttempts[connectionAttemptIndex].handleConnection(result: true)
         connectionAttempts.remove(at: connectionAttemptIndex)
     }
     
     func rejectConnection(endpointId: String) {
         guard let connectionAttemptIndex = connectionAttempts.firstIndex(where: {$0.endpointId == endpointId} ) else { return }
         connectionAttempts[connectionAttemptIndex].handleConnection(result: false)
         connectionAttempts.remove(at: connectionAttemptIndex)
     }
 }
