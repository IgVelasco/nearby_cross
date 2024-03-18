 //
 //  NCAdvertiser.swift
 //  nearby_cross
 //
 //  Created by Ignacio Velasco on 29/02/2024.
 //

 import Foundation


 import Foundation

 class Connector: ConnectionManagerDelegate {
     func connectionManager(_ connectionManager: ConnectionManager, didReceive verificationCode: String, from endpointID: EndpointID, verificationHandler: @escaping (Bool) -> Void) {
         // TODO
         // Optionally show the user the verification code. Your app should call this handler
         // with a value of `true` if the nearby endpoint should be trusted, or `false`
         // otherwise.
         verificationHandler(true)
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceive data: Data, withID payloadID: PayloadID, from endpointID: EndpointID) {
         // TODO
         // A simple byte payload has been received. This will always include the full data.
         print(data)
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
                 callbacks.onConnectionInitiated(endpointId: endpointID, endpointName: "TODO connecting state", alreadyAcceptedConnection: true)
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
     
     func sendData(data: Data, to endpointId: String) -> CancellationToken {
         return connectionManager.send(data, to: [endpointId], completionHandler: { err in
             print(err ?? "Sent data")
         })
     }
    
     let serviceId: String
     let context: UIApplication
     let callbacks: ConnectionCallbacks
     let userName: Data
     let strategy: Strategy
     let connectionManager: ConnectionManager
     var manualAcceptConnections: Bool

     init(serviceId: String,
          strategy: String,
          context: UIApplication,
          callbacks: ConnectionCallbacks,
          userName: String = GeneralConstants.DEFAULT_USERNAME,
          manualAcceptConnections: Bool = false) {
         self.serviceId = serviceId
         self.context = context
         self.callbacks = callbacks
         self.userName = userName.data(using: .utf8) ?? GeneralConstants.DEFAULT_USERNAME.data(using: .utf8)!
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
 }
