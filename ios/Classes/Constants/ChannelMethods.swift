//
//  Constants.swift
//  nearby_cross
//
//  Created by Ignacio Velasco on 29/02/2024.
//

import Foundation


struct ChannelMethods {
    static let GET_PLATFORM_VERSION = "getPlatformVersion"
    static let START_DISCOVERY = "startDiscovery"
    
    // Not Implemented
    static let START_ADVERTISING = "startAdvertising"
    static let SEND_DATA = "sendData"
    static let CONNECT = "connect"
    static let STOP_DISCOVERING = "stopDiscovering"
    static let STOP_ADVERTISING = "stopAdvertising"
    static let STOP_ALL_CONNECTIONS = "stopAllConnections"
    static let DISCONNECT_FROM = "disconnectFrom"
    static let ACCEPT_CONNECTION = "acceptConnection"
    static let REJECT_CONNECTION = "rejectConnection"

    // Connection Callbacks
    static let ON_ENDPOINT_FOUND = "onEndpointFound"
    static let ON_ENDPOINT_LOST = "onEndpointLost"
    static let ENPOINT_DISCONNECTED = "endpointDisconnected"
    static let CONNECTION_INITIATED = "connectionInitiated"
    static let SUCCESSFUL_CONNECTION = "successfulConnection"
    static let PAYLOAD_RECEIVED = "payloadReceived"
}
