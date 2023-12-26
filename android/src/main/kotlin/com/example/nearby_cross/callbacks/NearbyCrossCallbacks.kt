package com.example.nearby_cross.callbacks

import com.example.nearby_cross.constants.ChannelMethods
import io.flutter.plugin.common.MethodChannel

class NearbyCrossCallbacks(private val channel: MethodChannel) {
    val advertiser = object : AdvertiserCallbacks() {
        override fun onPayloadReceived(stringReceived: String) {
            channel.invokeMethod(ChannelMethods.ON_ENDPOINT_FOUND, stringReceived)
        }
    }

    val discoverer = object : DiscovererCallbacks() {
        override fun onEndpointFound(endpointId: String) {
            channel.invokeMethod(ChannelMethods.ON_ENDPOINT_FOUND, endpointId)
        }

        override fun onPayloadReceived(stringReceived: String) {
            channel.invokeMethod(ChannelMethods.ON_ENDPOINT_FOUND, stringReceived)
        }
    }
}