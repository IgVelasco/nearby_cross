package com.example.nearby_cross

import android.content.Context
import android.util.Log
import com.example.nearby_cross.callbacks.AdvertiserCallbacks
import com.example.nearby_cross.constants.Constants
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.*

/** NearbyCrossPlugin */
class Advertiser(
    private val serviceId: String,
    private val context: Context,
    private val callbacks: AdvertiserCallbacks,
    userName: String = Constants.DEFAULT_USERNAME,
) : Connector(userName) {

    private val payloadCallback = object : PayloadCallback() {
        override fun onPayloadReceived(endpointId: String, payload: Payload) {
            // This always gets the full data of the payload. Is null if it's not a BYTES payload.
            if (payload.type == Payload.Type.BYTES) {
                val receivedBytes = payload.asBytes()
                val stringReceived = receivedBytes?.let { String(it) }
                callbacks.onPayloadReceived(stringReceived as String)
                Log.d("INFO", "$stringReceived")
            }
        }

        override fun onPayloadTransferUpdate(endpointId: String, update: PayloadTransferUpdate) {
            // Bytes payloads are sent as a single chunk, so you'll receive a SUCCESS update immediately
            // after the call to onPayloadReceived().
            Log.v("INFO", "TRANSFER UPDATE")
        }
    }

    private val connectionLifecycleCallback = object : ConnectionLifecycleCallback() {
        override fun onConnectionInitiated(endpointId: String, connectionInfo: ConnectionInfo) {
            Log.v("INFO", connectionInfo.endpointName)
            Nearby.getConnectionsClient(context).acceptConnection(endpointId, payloadCallback);
            // A connection to another device has been initiated by the remote endpoint
            // You can now accept or reject the connection request using the provided ConnectionInfo
            // For example, you could show a dialog asking the user to confirm the connection
            // If the user accepts the connection, call Nearby.getConnectionsClient(context).acceptConnection(endpointId, payloadCallback) to accept the connection
            // If the user rejects the connection, call Nearby.getConnectionsClient(context).rejectConnection(endpointId) to reject the connection
        }

        override fun onConnectionResult(endpointId: String, result: ConnectionResolution) {
            // The result of a connection request, either successful or unsuccessful
            when (result.status.statusCode) {
                ConnectionsStatusCodes.STATUS_OK -> {
                    // Connection was successful!
                    // You can now start sending and receiving data using the provided EndpointDiscoveryCallback

                    // Add to connected endpoints
                    listOfConnectedEndpoints = listOfConnectedEndpoints + endpointId
                    Log.d("INFO", "Connected")


                }
                ConnectionsStatusCodes.STATUS_CONNECTION_REJECTED -> {
                    // The connection request was rejected by the remote endpoint
                    // You may want to notify the user that the connection was rejected
                    Log.d("ERROR", "Connection rejected")

                }
                ConnectionsStatusCodes.STATUS_ERROR -> {
                    // There was an error connecting to the remote endpoint
                    // You may want to notify the user that the connection was unsuccessful
                    Log.d("ERROR", "Failed to connect")

                }
                else -> {
                    Log.d("ERROR", "Failed to connect")
                }
                // Other status codes can be handled here as well
            }
        }

        override fun onDisconnected(endpointId: String) {
            // The connection to the remote endpoint has been disconnected
            // You may want to notify the user that the connection was lost
        }
    }
    
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


