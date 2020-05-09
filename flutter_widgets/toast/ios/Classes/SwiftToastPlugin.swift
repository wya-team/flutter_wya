import Flutter
import UIKit

public class SwiftToastPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "toast", binaryMessenger: registrar.messenger())
    let instance = SwiftToastPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "showToast" {
        let map = call.arguments as! [String : Any]
        if map["gravity"] as! String == "center" {
            let colorList = map["bgcolor"] as! [NSNumber]
            let textColorList = map["textcolor"] as! [NSNumber]

            UIView.wya_showCenterToast(withMessage: map["msg"] as! String,
                                       showTime: (map["time"] as! NSNumber).intValue,
                                       fontSize: (map["fontSize"] as! NSNumber).doubleValue,
                                       backgroundColor: UIColor(red: CGFloat(colorList[0].intValue)/255.0, green: CGFloat(colorList[1].intValue)/255.0, blue: CGFloat(colorList[2].intValue)/255.0, alpha: CGFloat(colorList[3].floatValue)),
                                       textColor: UIColor(red: CGFloat(textColorList[0].intValue)/255.0, green: CGFloat(textColorList[1].intValue)/255.0, blue: CGFloat(textColorList[2].intValue)/255.0, alpha: CGFloat(textColorList[3].floatValue)),
                                       bgViewUserInteractionUse: map["iosTouchBgDismiss"] as! Bool)
            result(true)
        } else if map["gravity"] as! String == "bottom" {
            let colorList = map["bgcolor"] as! [NSNumber]
            let textColorList = map["textcolor"] as! [NSNumber]
            UIView.wya_showBottomToast(withMessage: map["msg"] as! String,
            showTime: (map["time"] as! NSNumber).intValue,
            fontSize: (map["fontSize"] as! NSNumber).doubleValue,
            backgroundColor: UIColor(red: CGFloat(colorList[0].intValue)/255.0, green: CGFloat(colorList[1].intValue)/255.0, blue: CGFloat(colorList[2].intValue)/255.0, alpha: CGFloat(colorList[3].floatValue)),
            textColor: UIColor(red: CGFloat(textColorList[0].intValue)/255.0, green: CGFloat(textColorList[1].intValue)/255.0, blue: CGFloat(textColorList[2].intValue)/255.0, alpha: CGFloat(textColorList[3].floatValue)),
            bgViewUserInteractionUse: map["iosTouchBgDismiss"] as! Bool)
            result(true)
        } else {
            result(false)
        }

    } else if call.method == "showLoading" {
        let map = call.arguments as! [String : Any]
        let stateCode = (map["status"] as! NSNumber).intValue
        if  stateCode == 1 {
            UIView.wya_successToast(withMessage: map["msg"] as! String)
            result(true)
        } else if  stateCode == 0 {
            UIView.wya_toast(withMessage: map["msg"] as! String, imageString: "spin", autoRotation: true, imageType: WYAToastImageType.SVG, autoDismiss: map["canceledOnTouchOutside"] as! Bool, bgViewUserInteractionUse: true)
            result(true)
        } else if  stateCode == -1 {
            UIView.wya_failToast(withMessage: map["msg"] as! String)
            result(true)
        } else if  stateCode == -2 {
            UIView.wya_warningToast(withMessage: map["msg"] as! String)
            result(true)
        } else {
            result(false)
        }
    } else if call.method == "cancelLoading" {
        UIView.wya_dismissToast()
        result(true)
    }
  }
}
