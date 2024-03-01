//
//  NearbyCrossCallbacks.swift
//  nearby_cross
//
//  Created by Ignacio Velasco on 29/02/2024.
//

import Foundation


import Flutter

class NearbyCrossCallbacks {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    lazy var advertiser: AdvertiserCallbacks = {
        return AdvertiserCallbacksImpl(channel: channel)
    }()
}

class AdvertiserCallbacksImpl: AdvertiserCallbacks {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func onPayloadReceived(stringReceived: String, endpointId: String) {
        var hashmap = [String: Any]()
        hashmap["message"] = stringReceived
        hashmap["endpointId"] = endpointId
        channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, arguments: hashmap)
    }

    func onConnectionInitiated(endpointId: String, endpointName: String, alreadyAcceptedConnection: Bool) {
        var hashmap = [String: Any]()
        hashmap["endpointId"] = endpointId
        hashmap["endpointName"] = endpointName
        hashmap["alreadyAcceptedConnection"] = alreadyAcceptedConnection ? "1" : "0"
        channel.invokeMethod(ChannelMethods.CONNECTION_INITIATED, arguments: hashmap)
    }

    func onSuccessfulConnection(endpointId: String) {
        var hashmap = [String: Any]()
        hashmap["endpointId"] = endpointId
        channel.invokeMethod(ChannelMethods.SUCCESSFUL_CONNECTION, arguments: hashmap)
    }

    func onDisconnected(endpointId: String) {
        var hashmap = [String: Any]()
        hashmap["endpointId"] = endpointId
        channel.invokeMethod(ChannelMethods.ENPOINT_DISCONNECTED, arguments: hashmap)
    }
}
