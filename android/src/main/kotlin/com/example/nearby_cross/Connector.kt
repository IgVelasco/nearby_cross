package com.example.nearby_cross

import android.content.Context
import android.util.Log
import com.example.nearby_cross.callbacks.PayloadReceivedCallbacks
import com.example.nearby_cross.constants.ConnectionStrategies
import com.example.nearby_cross.constants.Constants
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.*
import java.nio.charset.Charset


// import com.google.android.gms.nearby.connection.AdvertisingOptions;


/** NearbyCrossPlugin */
open class Connector(
    protected val serviceId: String,
    strategy: String,
    protected val context: Context,
    callbacks: PayloadReceivedCallbacks,
    userName: String = Constants.DEFAULT_USERNAME

) {
    var userName: ByteArray
    var strategy: Strategy
    var listOfConnectedDevices: MutableMap<String, Device> = mutableMapOf()
    var listOfInitiatedConnections: MutableMap<String, Device> = mutableMapOf()


    init {
        this.userName = userName.toByteArray(Charset.forName("UTF-8"))
        this.strategy = getStrategy(strategy)
    }

    open fun disconnect(context: Context) {
        Nearby.getConnectionsClient(context).stopAllEndpoints()
        Log.v("INFO", "Stopped all endpoints")
        listOfConnectedDevices.clear()
        listOfInitiatedConnections.clear()
    }

    fun disconnectFromEndpointId(context: Context, endpointsId: String) {
        // Check what happens if ep id non existants
        Nearby.getConnectionsClient(context).disconnectFromEndpoint(endpointsId)
        listOfConnectedDevices.remove(endpointsId)
    }

    fun sendData(context: Context, data: String) {
        val bytesPayload = Payload.fromBytes(data.toByteArray())
        for (connection in listOfConnectedDevices) {
            Nearby.getConnectionsClient(context).sendPayload(connection.key, bytesPayload)
            Log.v("INFO", "Send'$data' to $connection")
        }
    }

    val payloadCallback = object : PayloadCallback() {
        override fun onPayloadReceived(endpointId: String, payload: Payload) {
            // This always gets the full data of the payload. Is null if it's not a BYTES payload.
            if (payload.type == Payload.Type.BYTES) {
                val receivedBytes = payload.asBytes()
                val stringReceived = receivedBytes?.let { String(it) }
                val device = listOfConnectedDevices[endpointId]
                callbacks.onPayloadReceived(stringReceived as String, device!!.endpointName)
            }
        }

        override fun onPayloadTransferUpdate(endpointId: String, update: PayloadTransferUpdate) {
            // Bytes payloads are sent as a single chunk, so you'll receive a SUCCESS update immediately
            // after the call to onPayloadReceived().
            Log.v("INFO", "TRANSFER UPDATE")
        }
    }

    val connectionLifecycleCallback = object : ConnectionLifecycleCallback() {
        override fun onConnectionInitiated(endpointId: String, connectionInfo: ConnectionInfo) {
            Log.v("INFO", connectionInfo.endpointName)

            val newInitiatedConnection = Device(endpointId, connectionInfo.endpointName)
            listOfInitiatedConnections[endpointId] = newInitiatedConnection

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
                    val newConnection =
                        listOfInitiatedConnections[endpointId]
                    if (newConnection == null) {
                        Log.d("ERROR", "Connection not found")
                        return
                    }

                    listOfInitiatedConnections.remove(endpointId)
                    listOfConnectedDevices[endpointId] = newConnection
                    Log.d("INFO", "Connected to ${newConnection.endpointName}")


                }
                ConnectionsStatusCodes.STATUS_CONNECTION_REJECTED -> {
                    listOfInitiatedConnections.remove(endpointId)

                    // The connection request was rejected by the remote endpoint
                    // You may want to notify the user that the connection was rejected
                    Log.d("ERROR", "Connection rejected")

                }
                ConnectionsStatusCodes.STATUS_ERROR -> {
                    listOfInitiatedConnections.remove(endpointId)

                    // There was an error connecting to the remote endpoint
                    // You may want to notify the user that the connection was unsuccessful
                    Log.d("ERROR", "Failed to connect")

                }
                else -> {
                    listOfInitiatedConnections.remove(endpointId)
                    Log.d("ERROR", "Failed to connect")
                }
                // Other status codes can be handled here as well
            }
        }

        override fun onDisconnected(endpointId: String) {
            // The connection to the remote endpoint has been disconnected
            // You may want to notify the user that the connection was lost
            listOfConnectedDevices.remove(endpointId)
        }
    }

    private fun getStrategy(strategy: String): Strategy {
        return when (strategy) {
            ConnectionStrategies.P2P_CLUSTER.name -> Strategy.P2P_CLUSTER
            ConnectionStrategies.P2P_STAR.name -> Strategy.P2P_STAR
            ConnectionStrategies.P2P_POINT_TO_POINT.name -> Strategy.P2P_POINT_TO_POINT
            else -> Strategy.P2P_STAR
        }
    }

}


