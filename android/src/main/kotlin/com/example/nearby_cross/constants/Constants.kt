package com.example.nearby_cross.constants

class Constants {
    companion object {
        const val PLUGIN_NAME = "nearby_cross";
        const val DEFAULT_USERNAME = "generic_name";
    }
}

class ChannelMethods {
    companion object {
        // Receive in native code
        const val GET_PLATFORM_VERSION = "getPlatformVersion";
        const val START_DISCOVERY = "startDiscovery";
        const val START_ADVERTISING = "startAdvertising";
        const val SEND_DATA = "sendData";
        const val CONNECT = "connect";
        const val DISCONNECT = "disconnect";

        // Send from native code
        const val ON_ENDPOINT_FOUND = "onEndpointFound";
        const val PAYLOAD_RECEIVED = "payloadReceived";
    }
}

enum class ConnectionStrategies {
    P2P_CLUSTER,
    P2P_STAR,
    P2P_POINT_TO_POINT
}
