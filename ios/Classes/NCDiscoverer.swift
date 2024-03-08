//
//  NCDiscoverer.swift
//  nearby_cross
//
//  Created by Juan Pablo Donato on 07/03/2024.
//

import Foundation


class NCDiscoverer: Connector, DiscovererDelegate {
    func discoverer(
        _ discoverer: Discoverer, didFind endpointID: EndpointID, with context: Data) {
        // An endpoint was found.
            (callbacks as! any DiscovererCallbacks as DiscovererCallbacks).onEndpointFound(endpointId: endpointID, endpointName: "My Device")
      }

      func discoverer(_ discoverer: Discoverer, didLose endpointID: EndpointID) {
        // A previously discovered endpoint has gone away.
      }
    
    func connect(endpointId: String) {
        discoverer?.requestConnection(to: endpointId, using: userName)
    }
   
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
   
    func startDiscovering() {
        discoverer!.startDiscovery()
    }
}
