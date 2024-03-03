 //
 //  NCAdvertiser.swift
 //  nearby_cross
 //
 //  Created by Ignacio Velasco on 29/02/2024.
 //

 import Foundation


 class NCAdvertiser: Connector, AdvertiserDelegate {
     func advertiser(_ advertiser: Advertiser, didReceiveConnectionRequestFrom endpointID: EndpointID, with context: Data, connectionRequestHandler: @escaping (Bool) -> Void) {
         // TODO
     }
    
     var advertiser: Advertiser?
    
     init(serviceId: String,
          strategy: String,
          context: UIApplication,
          callbacks: AdvertiserCallbacks,
          userName: String = GeneralConstants.DEFAULT_USERNAME,
          manualAcceptConnections: Bool = false) {
         self.advertiser = nil
          super.init(serviceId: serviceId,
                    strategy: strategy,
                    context: context,
                    callbacks: callbacks,
                    userName: userName,
                    manualAcceptConnections: manualAcceptConnections)
        
         advertiser = Advertiser(connectionManager: connectionManager)
         advertiser!.delegate = self
     }
    
     func startAdvertising() {
         advertiser!.startAdvertising(using: userName)
     }
 }
