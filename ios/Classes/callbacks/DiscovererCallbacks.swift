//
//  DiscovererCallbacks.swift
//  nearby_cross
//
//  Created by Juan Pablo Donato on 07/03/2024.
//

import Foundation

protocol DiscovererCallbacks: ConnectionCallbacks {
    // Additional methods specific to DiscovererCallbacks can be defined here

    func onEndpointFound(endpointId: String, endpointName: String)
    func onEndpointLost(endpointId: String)
}
