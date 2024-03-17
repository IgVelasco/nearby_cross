//
//  ConnectionCallbacks.swift
//  nearby_cross
//
//  Created by Ignacio Velasco on 29/02/2024.
//

import Foundation

protocol ConnectionCallbacks {
    func onPayloadReceived(bytesReceived: Data, endpointId: String)
    func onDisconnected(endpointId: String)
    func onConnectionInitiated(endpointId: String, endpointName: String, alreadyAcceptedConnection: Bool)
    func onSuccessfulConnection(endpointId: String)
}
