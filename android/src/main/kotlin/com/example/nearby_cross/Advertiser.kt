package com.example.nearby_cross

import android.content.Context
import android.util.Log
import com.example.nearby_cross.callbacks.AdvertiserCallbacks
import com.example.nearby_cross.constants.Constants
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.AdvertisingOptions
import com.google.android.gms.nearby.connection.Strategy

/** NearbyCrossPlugin */
class Advertiser(
    serviceId: String,
    context: Context,
    callbacks: AdvertiserCallbacks,
    userName: String = Constants.DEFAULT_USERNAME,
) : Connector(serviceId, context, callbacks, userName) {

    fun startAdvertising(context: Context) {
        val advertisingOptions = AdvertisingOptions.Builder().setStrategy(Strategy.P2P_STAR).build()
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
                    "We're advertising! Using service id: $serviceId and username $userName"
                )
            }
            .addOnFailureListener { e ->
                // We were unable to start discovery.
                Log.d("INFO", "We were unable to start advertising.")
            }
    }
}


