package com.example.nearby_cross.callbacks

abstract class ConnectionCallbacks {
    abstract fun onPayloadReceived(bytesReceived: ByteArray, endpointId: String)
    abstract fun onDisconnected(endpointId: String)
    abstract fun onConnectionInitiated(
        endpointId: String,
        endpointName: ByteArray,
        alreadyAcceptedConnection: Boolean
    )

    abstract fun onSuccessfulConnection(endpointId: String)

    abstract fun onRejectedConnection(endpointId: String)
}