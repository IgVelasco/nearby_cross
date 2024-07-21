//
//  NCDiscoverer.swift
//  nearby_cross
//
//  Created by Juan Pablo Donato on 07/03/2024.
//

import Foundation
import Flutter


class NCDiscoverer: Connector, DiscovererDelegate {
    lazy var discoverer: Discoverer = {
        let disc = Discoverer(connectionManager: connectionManager)
        disc.delegate = self
        return disc
    }()
    
    
    init(serviceId: String,
         strategy: String,
         context: UIApplication,
         callbacks: DiscovererCallbacks,
         userName: FlutterStandardTypedData) {
         super.init(serviceId: serviceId,
                   strategy: strategy,
                   context: context,
                   callbacks: callbacks,
                   userName: userName)
    }

    func discoverer(
        _ discoverer: Discoverer, didFind endpointID: EndpointID, with context: Data) {
            // An endpoint was found.
            let endpointName = context
            let endpointFound = ConnectionAttempt(
                endpointId: endpointID, endpointName: endpointName, connectionRequestHandler: {(a) in }
            )
            endpointsFounds.append(endpointFound)
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
        
        discoverer.requestConnection(to: endpointId, using: userName.data, completionHandler: completionHandler)
    }
   
    func startDiscovering() {
        let completionHandler: (Error?) -> Void  = {(error) in
            print(error ?? "Starting to discover devices in iOS")
        };

        discoverer.startDiscovery(completionHandler: completionHandler);
    }
}
