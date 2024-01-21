package com.example.nearby_cross

import android.content.Context
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.Payload

class DataManager {
    fun sendData(context: Context, data: String, endpointId: String) {
        val bytesPayload = Payload.fromBytes(data.toByteArray())
        Nearby.getConnectionsClient(context).sendPayload(endpointId, bytesPayload)
    }
}