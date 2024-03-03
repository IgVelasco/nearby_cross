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
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceive data: Data, withID payloadID: PayloadID, from endpointID: EndpointID) {
         // TODO
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceive stream: InputStream, withID payloadID: PayloadID, from endpointID: EndpointID, cancellationToken token: CancellationToken) {
         // TODO
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didStartReceivingResourceWithID payloadID: PayloadID, from endpointID: EndpointID, at localURL: URL, withName name: String, cancellationToken token: CancellationToken) {
         // TODO
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didReceiveTransferUpdate update: TransferUpdate, from endpointID: EndpointID, forPayload payloadID: PayloadID) {
         // TODO
     }
    
     func connectionManager(_ connectionManager: ConnectionManager, didChangeTo state: ConnectionState, for endpointID: EndpointID) {
         // TODO
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
