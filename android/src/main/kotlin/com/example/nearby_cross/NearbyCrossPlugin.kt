package com.example.nearby_cross

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.connection.Strategy;
import com.google.android.gms.nearby.connection.DiscoveryOptions;
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback;
import com.google.android.gms.nearby.connection.DiscoveredEndpointInfo;
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback;
import com.google.android.gms.nearby.connection.ConnectionInfo;
import com.google.android.gms.nearby.connection.ConnectionResolution;
import com.google.android.gms.nearby.connection.ConnectionsStatusCodes;
import android.content.Context;
import android.os.Build
import android.util.Log
import com.google.android.gms.nearby.connection.AdvertisingOptions
import java.nio.charset.Charset


// import com.google.android.gms.nearby.connection.AdvertisingOptions;


/** NearbyCrossPlugin */
class NearbyCrossPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var endpointDiscoveryCallback: EndpointDiscoveryCallback
  
  var listOfNearbyDevices: List<String> = listOf()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nearby_cross")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    endpointDiscoveryCallback = object : EndpointDiscoveryCallback() {
      override fun onEndpointFound(endpointId: String, info: DiscoveredEndpointInfo) {
          // A nearby device with the same service ID was found
          // You can now initiate a connection with this device using its endpoint ID
          Log.d("INFO", "A nearby device with the same service ID was found")
          listOfNearbyDevices = listOfNearbyDevices + endpointId
          channel.invokeMethod("onEndpointFound", endpointId);
      }

      override fun onEndpointLost(endpointId: String) {
          // The nearby device with the given endpoint ID is no longer available
          Log.d("INFO", "The nearby device with the given endpoint ID is no longer available $endpointId")
          listOfNearbyDevices = listOfNearbyDevices - endpointId
      }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "getPlatformVersion" -> {
            result.success("Android ${Build.VERSION.RELEASE}")
      }
      "generateColor" -> {
        val randomColor = generateColor()
        result.success(randomColor)
      }
      "startDiscovery" -> {
        val serviceId = call.arguments as String
        startDiscovery(context, serviceId)
        result.success(null)
      }
      "startAdvertising" -> {
        val serviceId = call.arguments as String
        startAdvertising(context, serviceId, "test")
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private val connectionLifecycleCallback = object : ConnectionLifecycleCallback() {
    override fun onConnectionInitiated(endpointId: String, connectionInfo: ConnectionInfo) {
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
            }
            ConnectionsStatusCodes.STATUS_CONNECTION_REJECTED -> {
                // The connection request was rejected by the remote endpoint
                // You may want to notify the user that the connection was rejected
            }
            ConnectionsStatusCodes.STATUS_ERROR -> {
                // There was an error connecting to the remote endpoint
                // You may want to notify the user that the connection was unsuccessful
            }
            // Other status codes can be handled here as well
        }
    }

    override fun onDisconnected(endpointId: String) {
        // The connection to the remote endpoint has been disconnected
        // You may want to notify the user that the connection was lost
    }
}


  fun startDiscovery(context: Context, serviceId: String)  {
      val discoveryOptions = DiscoveryOptions.Builder().setStrategy(Strategy.P2P_STAR).build()
      Nearby.getConnectionsClient(context)
          .startDiscovery(serviceId, this.endpointDiscoveryCallback, discoveryOptions)
          .addOnSuccessListener {
              // We're discovering! Using service id: $serviceId
            Log.d("INFO", "We're discovering! Using service id: $serviceId")
          }
          .addOnFailureListener { e ->
              // We were unable to start discovery.
            Log.d("INFO", "We were unable to start discovery.")
          }
  }


  fun startAdvertising(context: Context, serviceId: String, userName: String)  {
      val discoveryOptions = AdvertisingOptions.Builder().setStrategy(Strategy.P2P_STAR).build()
      val usernameBytes:ByteArray = userName.toByteArray(Charset.forName("UTF-8"))
      Nearby.getConnectionsClient(context).startAdvertising(usernameBytes, serviceId, this.connectionLifecycleCallback, discoveryOptions)
          .addOnSuccessListener {
              // We're discovering! Using service id: $serviceId
            Log.d("INFO", "We're advertising! Using service id: $serviceId")
          }
          .addOnFailureListener { e ->
              // We were unable to start discovery.
            Log.d("INFO", "We were unable to start advertising.")
          }
  }

  private fun generateColor(): List<Int> {
      return arrayOf(0, 0, 0).map { (Math.random() * 256).toInt() }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}


