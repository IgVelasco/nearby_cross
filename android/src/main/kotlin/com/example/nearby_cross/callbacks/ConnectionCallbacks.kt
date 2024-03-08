package com.example.nearby_cross.callbacks

abstract class ConnectionCallbacks {
    abstract fun onPayloadReceived(bytesReceived: ByteArray, endpointName: String)
    abstract fun onDisconnected(endpointId: String)
    abstract fun onConnectionInitiated(
        endpointId: String,
        endpointName: String,
        alreadyAcceptedConnection: Boolean
    )

    abstract fun onSuccessfulConnection(endpointId: String)
}