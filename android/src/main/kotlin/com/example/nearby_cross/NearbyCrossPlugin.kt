package com.example.nearby_cross

import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import com.example.nearby_cross.callbacks.NearbyCrossCallbacks
import com.example.nearby_cross.constants.ChannelMethods
import com.example.nearby_cross.constants.Constants
import com.example.nearby_cross.utils.InterfaceUtils
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
    private var dataManager: DataManager = DataManager()

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
                val userName = call.argument<ByteArray>("username") as ByteArray
                val strategy = call.argument<String>("strategy")
                this.discoverer = Discoverer(
                    serviceId as String,
                    strategy as String,
                    context,
                    callbacks.discoverer,
                    userName,
                )
                this.discoverer?.startDiscovering(context)
                result.success(null)
            }
            ChannelMethods.START_ADVERTISING -> {
                val serviceId = call.argument<String>("serviceId")
                val userName = call.argument<ByteArray>("username") as ByteArray
                val strategy = call.argument<String>("strategy")
                val manualAcceptConnections =
                    InterfaceUtils.parseStringAsBoolean(call.argument<String>("manualAcceptConnections") as String)
                this.advertiser = Advertiser(
                    serviceId as String,
                    strategy as String,
                    context,
                    callbacks.advertiser,
                    userName,
                    manualAcceptConnections
                )
                this.advertiser?.startAdvertising(context)
                result.success(null)
            }
            ChannelMethods.STOP_DISCOVERING -> {
                this.discoverer?.stopDiscovering(context)
                result.success(null)
            }
            ChannelMethods.STOP_ADVERTISING -> {
                this.advertiser?.stopAdvertising(context)
                result.success(null)
            }
            ChannelMethods.CONNECT -> {
                val endpointId = call.argument<String>("endpointId")
                this.discoverer?.connect(endpointId as String)
            }
            ChannelMethods.STOP_ALL_CONNECTIONS -> {
                this.advertiser?.stopAllConnections(context)
                this.discoverer?.stopAllConnections(context)
                result.success(null)
            }
            ChannelMethods.DISCONNECT_FROM -> {
                val endpointId = call.argument<String>("endpointId")
                this.advertiser?.disconnectFromEndpointId(context, endpointId as String)
                this.discoverer?.disconnectFromEndpointId(context, endpointId as String)
                result.success(null)
            }
            ChannelMethods.SEND_DATA -> {
                val data = call.argument<ByteArray>("data") as ByteArray
                val endpointId = call.argument<String>("endpointId") as String
                this.dataManager.sendData(context, data, endpointId)
                result.success(null)
            }
            ChannelMethods.ACCEPT_CONNECTION -> {
                val endpointId = call.argument<String>("endpointId") as String
                this.advertiser?.acceptConnection(endpointId)
                result.success(null)
            }
            ChannelMethods.REJECT_CONNECTION -> {
                val endpointId = call.argument<String>("endpointId") as String
                this.advertiser?.rejectConnection(endpointId)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}


