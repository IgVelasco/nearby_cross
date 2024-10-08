package com.example.nearby_cross

import android.content.Context
import android.util.Log
import com.example.nearby_cross.callbacks.AdvertiserCallbacks
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.AdvertisingOptions

/** NearbyCrossPlugin */
class Advertiser(
    serviceId: String,
    strategy: String,
    context: Context,
    callbacks: AdvertiserCallbacks,
    userName: ByteArray,
    manualAcceptConnections: Boolean = false
) : Connector(serviceId, strategy, context, callbacks, userName, manualAcceptConnections) {

    fun startAdvertising(context: Context) {
        val advertisingOptions = AdvertisingOptions.Builder().setStrategy(this.strategy).build()
        val usernameBytes: ByteArray = userName
        Nearby.getConnectionsClient(context).startAdvertising(
            usernameBytes,
            serviceId,
            this.connectionLifecycleCallback,
            advertisingOptions
        )
            .addOnSuccessListener {
                // We're discovering! Using service id: $serviceId
                Log.d(
                    "INFO",
                    "We're advertising in $strategy mode! Using service id: $serviceId " +
                            "and username $userName"
                )
            }
            .addOnFailureListener { e ->
                // We were unable to start discovery.
                Log.d("INFO", "We were unable to start advertising.")
            }
    }

    fun stopAdvertising(context: Context) {
        Nearby.getConnectionsClient(context).stopAdvertising()
        Log.d("INFO", "Stopped advertising")
    }
}


