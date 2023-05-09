import Flutter
import UIKit

public class NearbyCrossPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nearby_cross", binaryMessenger: registrar.messenger())
    let instance = NearbyCrossPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      break;
    case "generateColor":
      let randomColor = generateColor();
      result(randomColor);
      break;
    default:
      result("Not implemented");
      break;
    }
  }

  private func generateColor() -> [Int] {
    return [0,0,0].map { (v) -> Int in
      return Int.random(in: 0...255)}
  }
}
