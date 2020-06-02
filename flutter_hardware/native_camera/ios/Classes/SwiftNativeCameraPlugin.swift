import Flutter
import UIKit
import LSJHCamera

public class SwiftNativeCameraPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_camera", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeCameraPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "openCamera" {
        let map = call.arguments as! [String:Any]

        let cameraVC = WYACameraViewController(type: WYACameraType(rawValue: WYACameraType.RawValue((map["cameraType"] as! NSNumber).intValue))!, cameraOrientation: WYACameraOrientation(rawValue: WYACameraOrientation.RawValue((map["cameraOrientation"] as! NSNumber).intValue))!)

        cameraVC?.time      = CGFloat((map["time"] as! NSNumber).floatValue)
        let praset = (map["videoPreset"] as! NSNumber).intValue
        if praset == 0 {
            cameraVC?.preset = NSString(utf8String: AVCaptureSession.Preset.low.rawValue)
        } else if praset == 1 {
            cameraVC?.preset = NSString(utf8String: AVCaptureSession.Preset.medium.rawValue)
        } else {
            cameraVC?.preset = NSString(utf8String: AVCaptureSession.Preset.high.rawValue)
        }
        let save = map["saveAblum"] as! Bool
        if save {
            cameraVC?.saveAblum = save
            cameraVC?.albumName = (map["albumName"] as! String)
        }

        cameraVC?.takePhoto = {(photo, imagePath) in
            let imageData = photo?.pngData()
            let imageString = imageData?.base64EncodedString()
            let dic = NSMutableDictionary(objects: [imageString!], forKeys: ["imageBase64" as NSCopying])
            if imagePath != nil {
                dic["imagePath"] = imagePath
            }
            result(dic)
        }
        cameraVC?.takeVideo = {(videoPath) in
            let dic = NSDictionary(objects: [videoPath as Any], forKeys: ["videoPath" as NSCopying])
            result(dic)
        }
        let window = UIApplication.shared.keyWindow
        window?.rootViewController?.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(cameraVC!, animated: true, completion: nil)

    }
  }
}
