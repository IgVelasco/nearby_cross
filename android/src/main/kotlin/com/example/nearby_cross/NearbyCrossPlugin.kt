package com.example.nearby_cross

import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import com.example.nearby_cross.callbacks.NearbyCrossCallbacks
import com.example.nearby_cross.constants.ChannelMethods
import com.example.nearby_cross.constants.Constants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NearbyCrossPlugin */
class NearbyCrossPlugin : FlutterPlugin, MethodCallHandler {

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var callbacks: NearbyCrossCallbacks
    private var advertiser: Advertiser? = null
    private var discoverer: Discoverer? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, Constants.PLUGIN_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        callbacks = NearbyCrossCallbacks(channel)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            ChannelMethods.GET_PLATFORM_VERSION -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            ChannelMethods.START_DISCOVERY -> {
                val serviceId = call.argument<String>("serviceId")
                val userName = call.argument<String>("username")
                val strategy = call.argument<String>("strategy")
                this.discoverer = Discoverer(
                    serviceId as String,
                    strategy as String,
                    context,
                    callbacks.discoverer,
                    userName as String,
                )
                this.discoverer?.startDiscovery(context)
                result.success(null)
            }
            ChannelMethods.START_ADVERTISING -> {
                val serviceId = call.argument<String>("serviceId")
                val userName = call.argument<String>("username")
                val strategy = call.argument<String>("strategy")
                this.advertiser = Advertiser(
                    serviceId as String,
                    strategy as String,
                    context,
                    callbacks.advertiser,
                    userName as String,
                )
                this.advertiser?.startAdvertising(context)
                result.success(null)
            }
            ChannelMethods.DISCONNECT -> {
                val serviceId = call.arguments as String
                this.advertiser?.disconnect(context, serviceId)
                this.discoverer?.disconnect(context, serviceId)
                result.success(null)
            }
            ChannelMethods.SEND_DATA -> {
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


