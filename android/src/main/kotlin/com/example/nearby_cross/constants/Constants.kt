package com.example.nearby_cross.constants

class Constants {
    companion object {
        const val PLUGIN_NAME = "nearby_cross";
        const val DEFAULT_USERNAME = "generic_name";
    }
}

class ChannelMethods {
    companion object {
        // Receive
        const val GET_PLATFORM_VERSION = "getPlatformVersion";
        const val START_DISCOVERY = "startDiscovery";
        const val START_ADVERTISING = "startAdvertising";
        const val DISCONNECT = "disconnect";
        const val SEND_DATA = "sendData";

        // Send
        const val ON_ENDPOINT_FOUND = "onEndpointFound";
    }
}