import Flutter
import UIKit

public class SwiftCachePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cache", binaryMessenger: registrar.messenger())
    let instance = SwiftCachePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if call.method == "getSystemCache" {
        WYAClearCache.wya_cacheFileSize(atPath: (call.arguments as! [String]).first!) { (msg) in
            result(msg)
        }
    } else if call.method == "clearCache" {
        WYAClearCache.wya_clearFile(atPath: (call.arguments as! [String]).first!) { (msg) in
            result(msg)
        }
    } else if call.method == "availableSpace" {
        result(WYAClearCache.wya_getDivceSize())
    } else if call.method == "deviceCacheSpace" {
        result(WYAClearCache.wya_getDivceTotalSize())
    }

  }
}
