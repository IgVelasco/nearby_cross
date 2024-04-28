package com.example.nearby_cross.callbacks

import com.example.nearby_cross.constants.ChannelMethods
import io.flutter.plugin.common.MethodChannel

class NearbyCrossCallbacks(private val channel: MethodChannel) {
    val advertiser = object : AdvertiserCallbacks() {
        override fun onPayloadReceived(bytesReceived: ByteArray, endpointId: String) {
            val hashmap = HashMap<String, Any>()
            hashmap["message"] = bytesReceived
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, hashmap)
        }

        override fun onConnectionInitiated(
            endpointId: String,
            endpointName: ByteArray,
            alreadyAcceptedConnection: Boolean
        ) {
            val hashmap = HashMap<String, Any>()
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

        override fun onRejectedConnection(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.CONNECTION_REJECTED, hashmap)
        }

        override fun onDisconnected(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.ENDPOINT_DISCONNECTED, hashmap)
        }
    }

    val discoverer = object : DiscovererCallbacks() {
        override fun onEndpointFound(endpointId: String, endpointName: ByteArray) {
            val hashmap = HashMap<String, Any>()
            hashmap["endpointId"] = endpointId
            hashmap["endpointName"] = endpointName
            channel.invokeMethod(ChannelMethods.ON_ENDPOINT_FOUND, hashmap)
        }

        override fun onEndpointLost(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.ON_ENDPOINT_LOST, hashmap)
        }

        override fun onPayloadReceived(bytesReceived: ByteArray, endpointId: String) {
            val hashmap = HashMap<String, Any>()
            hashmap["message"] = bytesReceived
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.PAYLOAD_RECEIVED, hashmap)
        }

        override fun onConnectionInitiated(
            endpointId: String,
            endpointName: ByteArray,
            alreadyAcceptedConnection: Boolean
        ) {
            val hashmap = HashMap<String, Any>()
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

        override fun onRejectedConnection(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.CONNECTION_REJECTED, hashmap)
        }

        override fun onDisconnected(endpointId: String) {
            val hashmap = HashMap<String, String>()
            hashmap["endpointId"] = endpointId
            channel.invokeMethod(ChannelMethods.ENDPOINT_DISCONNECTED, hashmap)
        }
    }
}