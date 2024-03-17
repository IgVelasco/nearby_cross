//
//  NCDiscoverer.swift
//  nearby_cross
//
//  Created by Juan Pablo Donato on 07/03/2024.
//

import Foundation


class NCDiscoverer: Connector, DiscovererDelegate {
    var discoverer: Discoverer?

    init(serviceId: String,
         strategy: String,
         context: UIApplication,
         callbacks: DiscovererCallbacks,
         userName: String = GeneralConstants.DEFAULT_USERNAME) {
         self.discoverer = nil
         super.init(serviceId: serviceId,
                   strategy: strategy,
                   context: context,
                   callbacks: callbacks,
                   userName: userName)
       
        discoverer = Discoverer(connectionManager: connectionManager)
        discoverer!.delegate = self
    }

    func discoverer(
        _ discoverer: Discoverer, didFind endpointID: EndpointID, with context: Data) {
            // An endpoint was found.
            var endpointName = String(decoding: context, as: UTF8.self)
            (callbacks as! any DiscovererCallbacks as DiscovererCallbacks)
                .onEndpointFound(
                    endpointId: endpointID,
                    endpointName: endpointName
                )
    }

      func discoverer(_ discoverer: Discoverer, didLose endpointID: EndpointID) {
          // A previously discovered endpoint has gone away.
          (callbacks as! any DiscovererCallbacks as DiscovererCallbacks).onEndpointLost(endpointId: endpointID)
      }
    
    func connect(endpointId: String) {
        let completionHandler: (Error?) -> Void  = {(error) in
            print(error ?? "Requested connection to \(endpointId)")
        };
        
        discoverer?.requestConnection(to: endpointId, using: userName)
    }
   
    func startDiscovering() {
        let completionHandler: (Error?) -> Void  = {(error) in
            print(error ?? "Starting to discover devices in iOS")
        };

        discoverer!.startDiscovery(completionHandler: completionHandler);
    }
}
