package com.example.nearby_cross.constants

class Constants {
    companion object {
        const val PLUGIN_NAME = "nearby_cross"
        const val DEFAULT_USERNAME = "generic_name" // TODO: add phone data or a random to improve default uuid
    }
}

class ChannelMethods {
    companion object {
        // Receive in native code
        const val GET_PLATFORM_VERSION = "getPlatformVersion"
        const val START_DISCOVERY = "startDiscovery"
        const val START_ADVERTISING = "startAdvertising"
        const val SEND_DATA = "sendData"
        const val CONNECT = "connect"
        const val DISCONNECT = "disconnect"
        const val DISCONNECT_FROM_EP_NAME = "disconnectFromEndpointName"
        const val DISCONNECT_FROM_EP_ID = "disconnectFromEndpointId"
        const val ACCEPT_CONNECTION = "acceptConnection"
        const val REJECT_CONNECTION = "rejectConnection"

        // Connection Callbacks
        const val ON_ENDPOINT_FOUND = "onEndpointFound"
        const val CONNECTION_INITIATED = "connectionInitiated"
        const val SUCCESSFUL_CONNECTION = "successfulConnection"
        const val PAYLOAD_RECEIVED = "payloadReceived"
    }
}

enum class ConnectionStrategies {
    P2P_CLUSTER,
    P2P_STAR,
    P2P_POINT_TO_POINT
}
