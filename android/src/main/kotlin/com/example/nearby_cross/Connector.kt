package com.example.nearby_cross

import android.content.Context
import android.util.Log
import com.example.nearby_cross.constants.Constants
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.Payload
import java.nio.charset.Charset


// import com.google.android.gms.nearby.connection.AdvertisingOptions;


/** NearbyCrossPlugin */
open class Connector(
    userName: String = Constants.DEFAULT_USERNAME
) {
    var userName: ByteArray
    var listOfNearbyDevices: List<String> = listOf()
    var listOfConnectedEndpoints: List<String> = listOf()

    init {
        this.userName = userName.toByteArray(Charset.forName("UTF-8"))
    }

    fun disconnect(context: Context, serviceId: String) {
        Nearby.getConnectionsClient(context).stopAllEndpoints()
        listOfConnectedEndpoints = listOf()
        listOfNearbyDevices = listOf()
        Log.v("INFO", "Stopped all endpoints")
    }

    fun sendData(context: Context, data: String) {
        val bytesPayload = Payload.fromBytes(data.toByteArray())
        for (connectedDevice in listOfConnectedEndpoints) {
            Nearby.getConnectionsClient(context).sendPayload(connectedDevice, bytesPayload)
            Log.v("INFO", "Send'$data' to $connectedDevice")
        }
    }
}


