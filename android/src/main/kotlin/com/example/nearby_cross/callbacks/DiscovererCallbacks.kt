package com.example.nearby_cross.callbacks

abstract class DiscovererCallbacks : ConnectionCallbacks() {
    abstract fun onEndpointFound(endpointId: String, endpointName: String)
}