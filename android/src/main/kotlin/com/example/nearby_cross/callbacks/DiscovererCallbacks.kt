package com.example.nearby_cross.callbacks

abstract class DiscovererCallbacks : PayloadReceivedCallbacks() {
    abstract fun onEndpointFound(endpointId: String, endpointName: String)
}