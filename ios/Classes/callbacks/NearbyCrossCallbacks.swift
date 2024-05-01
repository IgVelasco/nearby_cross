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
    
    lazy var discoverer: DiscovererCallbacks = {
        return DiscovererCallbacksImpl(channel: channel)
    }()
}

class AdvertiserCallbacksImpl: AdvertiserCallbacks {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func onPayloadReceived(bytesReceived: Data, endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["message"] = bytesReceived
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, arguments: hashmap)
    }

    func onConnectionInitiated(endpointId: String, endpointName: Data, alreadyAcceptedConnection: Bool) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        hashmap["endpointName"] = endpointName
        hashmap["alreadyAcceptedConnection"] = alreadyAcceptedConnection ? "1".data(using: .utf8) : "0".data(using: .utf8)
        channel.invokeMethod(ChannelMethods.CONNECTION_INITIATED, arguments: hashmap)
    }

    func onSuccessfulConnection(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.SUCCESSFUL_CONNECTION, arguments: hashmap)
    }
    
    func onRejectedConnection(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.CONNECTION_REJECTED, arguments: hashmap)
    }

    func onDisconnected(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.ENDPOINT_DISCONNECTED, arguments: hashmap)
    }
}

class DiscovererCallbacksImpl: DiscovererCallbacks {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func onPayloadReceived(bytesReceived: Data, endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["message"] = bytesReceived
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, arguments: hashmap)
    }

    func onConnectionInitiated(endpointId: String, endpointName: Data, alreadyAcceptedConnection: Bool) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        hashmap["endpointName"] = endpointName
        hashmap["alreadyAcceptedConnection"] = alreadyAcceptedConnection ? "1".data(using: .utf8) : "0".data(using: .utf8)
        channel.invokeMethod(ChannelMethods.CONNECTION_INITIATED, arguments: hashmap)
    }

    func onSuccessfulConnection(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.SUCCESSFUL_CONNECTION, arguments: hashmap)
    }
    
    func onRejectedConnection(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.CONNECTION_REJECTED, arguments: hashmap)
    }

    func onDisconnected(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.ENDPOINT_DISCONNECTED, arguments: hashmap)
    }
    
    func onEndpointFound(endpointId: String, endpointName: Data) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        hashmap["endpointName"] = endpointName
        channel.invokeMethod(ChannelMethods.ON_ENDPOINT_FOUND, arguments: hashmap)
    }

    func onEndpointLost(endpointId: String) {
        var hashmap = [String: Data]()
        hashmap["endpointId"] = endpointId.data(using: .utf8)
        channel.invokeMethod(ChannelMethods.ON_ENDPOINT_LOST, arguments: hashmap)
    }
}
