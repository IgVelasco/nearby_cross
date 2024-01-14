package com.example.nearby_cross.callbacks

abstract class ConnectionCallbacks {
    abstract fun onPayloadReceived(stringReceived: String, endpointName: String)
    abstract fun onConnectionInitiated(endpointId: String, endpointName: String)
    abstract fun onSuccessfulConnection(endpointId: String)
}