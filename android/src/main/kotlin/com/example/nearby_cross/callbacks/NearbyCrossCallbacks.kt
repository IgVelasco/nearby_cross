package com.example.nearby_cross.callbacks

import com.example.nearby_cross.constants.ChannelMethods
import io.flutter.plugin.common.MethodChannel

class NearbyCrossCallbacks(private val channel: MethodChannel) {
    val advertiser = object : AdvertiserCallbacks() {
        override fun onPayloadReceived(stringReceived: String, endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["message"] = stringReceived
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, hashmap)
        }

        override fun onConnectionInitiated(
            endpointId: String,
            endpointName: String,
            alreadyAcceptedConnection: Boolean
        ) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            hashmap["endpointName"] = endpointName
            hashmap["alreadyAcceptedConnection"] = if (alreadyAcceptedConnection) "1" else "0"
            channel.invokeMethod(ChannelMethods.CONNECTION_INITIATED, hashmap)
        }

        override fun onSuccessfulConnection(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.SUCCESSFUL_CONNECTION, hashmap)
        }

        override fun onDisconnected(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.ENPOINT_DISCONNECTED, hashmap)
        }
    }

    val discoverer = object : DiscovererCallbacks() {
        override fun onEndpointFound(endpointId: String, endpointName: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            hashmap["endpointName"] = endpointName
            channel.invokeMethod(ChannelMethods.ON_ENDPOINT_FOUND, hashmap)
        }

        override fun onPayloadReceived(stringReceived: String, endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["message"] = stringReceived
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, hashmap)
        }

        override fun onConnectionInitiated(
            endpointId: String,
            endpointName: String,
            alreadyAcceptedConnection: Boolean
        ) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            hashmap["endpointName"] = endpointName
            hashmap["alreadyAcceptedConnection"] = if (alreadyAcceptedConnection) "1" else "0"
            channel.invokeMethod(ChannelMethods.CONNECTION_INITIATED, hashmap)
        }

        override fun onSuccessfulConnection(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.SUCCESSFUL_CONNECTION, hashmap)
        }

        override fun onDisconnected(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.ENPOINT_DISCONNECTED, hashmap)
        }
    }
}