 //
 //  NCAdvertiser.swift
 //  nearby_cross
 //
 //  Created by Ignacio Velasco on 29/02/2024.
 //

import Foundation
import Flutter

class ConnectionAttempt {
    var endpointId: String
    var endpointName: Data
    var connectionRequestHandler: (Bool) -> Void
    var connected: Bool?
    
    init(endpointId: String, endpointName: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
        self.endpointId = endpointId
        self.endpointName = endpointName
        self.connectionRequestHandler = connectionRequestHandler
    }
    
    func handleConnection(result: Bool) {
        connectionRequestHandler(result)
        connected = result
    }
}

 class Connector: ConnectionManagerDelegate {
     var endpointsFounds: [ConnectionAttempt] = []
     
     func connectionManager(_ connectionManager: ConnectionManager, didReceive verificationCode: String, from endpointID: EndpointID, verificationHandler: @escaping (Bool) -> Void) {
         // TODO
         // Optionally show the user the verification code. Your app should call this handler
         // with a value of `true` if the nearby endpoint should be trusted, or `false`
         // otherwise.
         verificationHandler(true)
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceive data: Data, withID payloadID: PayloadID, from endpointID: EndpointID) {
         // A simple byte payload has been received. This will always include the full data.
         callbacks.onPayloadReceived(bytesReceived: data, endpointId: endpointID)
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceive stream: InputStream, withID payloadID: PayloadID, from endpointID: EndpointID, cancellationToken token: CancellationToken) {
         // TODO
         // We have received a readable stream.
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didStartReceivingResourceWithID payloadID: PayloadID, from endpointID: EndpointID, at localURL: URL, withName name: String, cancellationToken token: CancellationToken) {
         // TODO
         // We have started receiving a file. We will receive a separate transfer
         // event when complete.
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceiveTransferUpdate update: TransferUpdate, from endpointID: EndpointID, forPayload payloadID: PayloadID) {
         // TODO We have to manage payloads as they are not sent atomically
         // A success, failure, cancelation or progress update.
         switch update {
         case .success:
             print("success")
         case .canceled:
             print("canceled")
         case .failure:
             print("failure")
         case let .progress(progress):
             print("progress")
         }
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didChangeTo state: ConnectionState, for endpointID: EndpointID) {
         switch state {
             case .connecting:
               // A connection to the remote endpoint is currently being established.
                 print("connecting")
                 let endpointName: Data;
                 if let endpointFoundIndex = endpointsFounds.firstIndex(where: {$0.endpointId == endpointID} ) {
                     endpointName = endpointsFounds[endpointFoundIndex].endpointName
                     endpointsFounds.remove(at: endpointFoundIndex)
                 } else {
                     endpointName = "TODO connecting state".data(using: .utf8)!
                 }
             
                callbacks.onConnectionInitiated(endpointId: endpointID, endpointName: endpointName, alreadyAcceptedConnection: true)
             break;
             case .connected:
               // We're connected! Can now start sending and receiving data.
                 print("connected")
                 callbacks.onSuccessfulConnection(endpointId: endpointID)
             break;
             case .disconnected:
               // We've been disconnected from this endpoint. No more data can be sent or received.
                print("disconnected")
                callbacks.onDisconnected(endpointId: endpointID)
             break;
             case .rejected:
               // The connection was rejected by one or both sides.
                 print("rejected")
                 callbacks.onRejectedConnection(endpointId: endpointID)
             break;
         }
     }
     
     func sendData(data: Data, to endpointId: String) -> CancellationToken {
         return connectionManager.send(data, to: [endpointId], completionHandler: { err in
             print(err ?? "Sent data")
         })
     }
     
     func disconnectFrom(from endpointId: String) {
         let completionHandler: (Error?) -> Void  = {(error) in
             print(error ?? "Error while trying to disconnect from \(endpointId)")
         };

         return connectionManager.disconnect(from: endpointId, completionHandler: completionHandler)
     }
    
     let serviceId: String
     let context: UIApplication
     let callbacks: ConnectionCallbacks
     let userName: FlutterStandardTypedData
     let strategy: Strategy
     let connectionManager: ConnectionManager
     var manualAcceptConnections: Bool

     init(serviceId: String,
          strategy: String,
          context: UIApplication,
          callbacks: ConnectionCallbacks,
          userName: FlutterStandardTypedData,
          manualAcceptConnections: Bool = false) {
         self.serviceId = serviceId
         self.context = context
         self.callbacks = callbacks
         self.userName = userName
         self.strategy = Connector.getStrategy(strategy)
         self.manualAcceptConnections = manualAcceptConnections
         connectionManager = ConnectionManager(serviceID: serviceId, strategy: self.strategy)
         connectionManager.delegate = self
     }
    
     static func getStrategy(_ strategy: String) -> Strategy {
         guard let connectionStrategy = ConnectionStrategies(rawValue: strategy) else {
             return .star // Default strategy if not found
         }
         switch connectionStrategy {
             case .P2P_CLUSTER:
                 return .cluster
             case .P2P_STAR:
                 return .star
             case .P2P_POINT_TO_POINT:
             return .pointToPoint
         }
     }

     func disconnectFromAll() {
         endpointsFounds.forEach { connectionAttempt in
             disconnectFrom(from: connectionAttempt.endpointId)
         }
     }
 }
