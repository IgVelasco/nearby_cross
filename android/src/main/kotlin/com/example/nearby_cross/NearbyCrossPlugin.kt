package com.example.nearby_cross

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.nio.charset.Charset


// import com.google.android.gms.nearby.connection.AdvertisingOptions;


/** NearbyCrossPlugin */
class NearbyCrossPlugin : FlutterPlugin, MethodCallHandler {

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var advertiser: Advertiser? = null
    private var discoverer: Discoverer? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nearby_cross")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "startDiscovery" -> {
                val serviceId = call.argument<String>("serviceId")
                val userName = call.argument<String>("username")
                this.discoverer = Discoverer(serviceId as String, context, channel, userName as String)
                this.discoverer?.startDiscovery(context)
                result.success(null)
            }
            "startAdvertising" -> {
                val serviceId = call.argument<String>("serviceId")
                val userName = call.argument<String>("username")
                this.advertiser =
                    Advertiser(serviceId as String, context, channel, userName as String)
                this.advertiser?.startAdvertising(context)
                result.success(null)
            }
            "disconnect" -> {
                val serviceId = call.arguments as String
                this.advertiser?.disconnect(context, serviceId)
                this.discoverer?.disconnect(context, serviceId)
                result.success(null)
            }
            "sendData" -> {
                val data = call.arguments as String
                this.advertiser?.sendData(context, data)
                this.discoverer?.sendData(context, data)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}


