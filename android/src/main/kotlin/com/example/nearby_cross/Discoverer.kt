package com.example.nearby_cross

import android.content.Context
import android.util.Log
import com.example.nearby_cross.callbacks.DiscovererCallbacks
import com.example.nearby_cross.constants.Constants
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.DiscoveredEndpointInfo
import com.google.android.gms.nearby.connection.DiscoveryOptions
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback

/** NearbyCrossPlugin */
class Discoverer(
    serviceId: String,
    strategy: String,
    context: Context,
    callbacks: DiscovererCallbacks,
    userName: String = Constants.DEFAULT_USERNAME,
) : Connector(serviceId, strategy, context, callbacks, userName) {
    private var endpointDiscoveryCallback: EndpointDiscoveryCallback

    init {
        this.endpointDiscoveryCallback = object : EndpointDiscoveryCallback() {
            override fun onEndpointFound(endpointId: String, info: DiscoveredEndpointInfo) {
                // A nearby device with the same service ID was found
                // You can now initiate a connection with this device using its endpoint ID
                Log.d("INFO", "A nearby device with the same service ID was found")
                callbacks.onEndpointFound(endpointId, info.endpointName)
            }

            override fun onEndpointLost(endpointId: String) {
                // The nearby device with the given endpoint ID is no longer available
                Log.d(
                    "INFO",
                    "The nearby device with the given endpoint ID is no longer available $endpointId"
                )
                callbacks.onEndpointLost(endpointId)
            }
        }

        Log.d("info", "Discoverer init completed")
    }

    fun startDiscovering(context: Context) {
        val discoveryOptions = DiscoveryOptions.Builder().setStrategy(this.strategy).build()
        Nearby.getConnectionsClient(context)
            .startDiscovery(this.serviceId, this.endpointDiscoveryCallback, discoveryOptions)
            .addOnSuccessListener {
                // We're discovering! Using service id: $serviceId
                Log.d("INFO", "We're discovering! Using service id: $this.serviceId")
            }
            .addOnFailureListener { e ->
                // We were unable to start discovery.
                Log.d("INFO", "We were unable to start discovery.")
            }
    }

    fun stopDiscovering(context: Context) {
        Nearby.getConnectionsClient(context).stopDiscovery()
        Log.d("INFO", "Stopped discovery")
    }

    fun connect(endpointId: String) {
        Nearby.getConnectionsClient(context)
            .requestConnection(userName, endpointId, connectionLifecycleCallback)
    }


}


