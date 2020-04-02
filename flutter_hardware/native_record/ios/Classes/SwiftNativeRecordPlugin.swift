import Flutter
import UIKit

public class SwiftNativeRecordPlugin: NSObject, FlutterPlugin {

    var recordManager = WYAAudioRecoder.sharedManager()


  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_record", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeRecordPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let list = call.arguments as? [Any]

    if call.method == "recordPlay" {
        result(recordManager.wya_startPlayAudio(with: URL.init(fileURLWithPath: list?.first as! String, isDirectory: false), volume: list?[1] as! CGFloat, speed: list?[2] as! CGFloat, numberOfLoops: list?[3] as! Int, currentTime: list?.last as! TimeInterval))
    } else if call.method == "recordPause" {
        recordManager.wya_pausePlayAudio()
    } else if call.method == "recordResume" {
        recordManager.wya_resumePlayAudio()
    } else if call.method == "recordStop" {
        recordManager.wya_stopPlayAudio()
    }
  }
}
