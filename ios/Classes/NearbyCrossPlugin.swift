import Flutter
import UIKit


public class NearbyCrossPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel
    private var context: UIApplication
    private var callbacks: NearbyCrossCallbacks
    private var advertiser: NCAdvertiser?
    private var discoverer: NCDiscoverer?

    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        self.context = UIApplication.shared
        self.callbacks = NearbyCrossCallbacks(channel: channel)
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: GeneralConstants.PLUGIN_NAME, binaryMessenger: registrar.messenger())
        let instance = NearbyCrossPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case ChannelMethods.GET_PLATFORM_VERSION:
          result("iOS " + UIDevice.current.systemVersion)
        case ChannelMethods.START_ADVERTISING:
            guard let args = call.arguments as? [String: Any],
                  let serviceId = args["serviceId"] as? String,
                  let userName = args["username"] as? String,
                  let strategy = args["strategy"] as? String,
                  let manualAcceptConnections = args["manualAcceptConnections"] as? String  else {
                      result(FlutterError(code: "argument_error", message: "Missing arguments", details: nil))
                      return
            }
            if (advertiser == nil) {
                advertiser = NCAdvertiser(serviceId: serviceId, strategy: strategy, context: context, callbacks: callbacks.advertiser, userName: userName, manualAcceptConnections:  manualAcceptConnections == "1")
            }
            
            advertiser?.startAdvertising()
            result(nil)
        case ChannelMethods.START_DISCOVERY:
            guard let args = call.arguments as? [String: Any],
                  let serviceId = args["serviceId"] as? String,
                  let userName = args["username"] as? String,
                  let strategy = args["strategy"] as? String else {
                      result(FlutterError(code: "argument_error", message: "Missing arguments", details: nil))
                      return
            }
            if (discoverer == nil) {
                discoverer = NCDiscoverer(serviceId: serviceId, strategy: strategy, context: context, callbacks: callbacks.discoverer, userName: userName)
            }
            
            discoverer?.startDiscovering()
            result(nil)
        case ChannelMethods.CONNECT:
            guard let args = call.arguments as? [String: Any],
                  let endpointId = args["endpointId"] as? String else {
                result(FlutterError(code: "argument_error", message: "Missing arguments", details: nil))
                return
            }
            
            discoverer?.connect(endpointId: endpointId)
            result(nil)
        case ChannelMethods.SEND_DATA:
            guard let args = call.arguments as? [String: Any],
                  let data = args["data"] as? FlutterStandardTypedData,
                  let endpointId = args["endpointId"] as? String else {
                result(FlutterError(code: "argument_error", message: "Missing arguments", details: nil))
                return
            }
            
            if (discoverer != nil) {
                var _ = discoverer?.sendData(data: Data(data.data), to: endpointId)
            } else if (advertiser != nil) {
                var _ = advertiser?.sendData(data: Data(data.data), to: endpointId)
            }

            result(nil)
        case ChannelMethods.ACCEPT_CONNECTION:
            guard let args = call.arguments as? [String: Any],
                  let endpointId = args["endpointId"] as? String else {
                result(FlutterError(code: "argument_error", message: "Missing arguments", details: nil))
                return
            }
            
            advertiser?.acceptConnection(endpointId: endpointId)
            result(nil)
            break;
        case ChannelMethods.REJECT_CONNECTION:
            guard let args = call.arguments as? [String: Any],
                  let endpointId = args["endpointId"] as? String else {
                result(FlutterError(code: "argument_error", message: "Missing arguments", details: nil))
                return
            }
            
            advertiser?.rejectConnection(endpointId: endpointId)
            result(nil)
            break;
        default:
          result("Not implemented")
        }
        
    }
}
