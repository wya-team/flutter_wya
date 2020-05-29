import Flutter
import UIKit
import LSJHPhotoBrowser

public class SwiftNativeGalleryPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_gallery", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeGalleryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "openAlbum" {
        let map = call.arguments as! [String:Any]
        let photo = WYAPhotoBrowser()
        photo.config.maxSelectCount = (map["maxSelectCount"] as! NSNumber).intValue
        photo.config.sortAscending       = map["sortAscending"] as! Bool
        photo.config.allowSelectImage      = map["allowSelectImage"] as! Bool
        photo.config.allowSelectVideo    = map["allowSelectVideo"] as! Bool
        photo.config.allowSelectOriginal = map["allowSelectOriginal"] as! Bool
        photo.config.allowEditImage = map["allowEditImage"] as! Bool
        photo.config.allowEditVideo      = map["allowEditVideo"] as! Bool
        photo.config.canTakePicture = map["canTakePicture"] as! Bool
        photo.config.allowChoosePhotoAndVideo = map["allowChoosePhotoAndVideo"] as! Bool
        photo.config.maxVideoDuration = (map["maxVideoDuration"] as! NSNumber).intValue
        photo.config.maxEditVideoTime = (map["maxEditVideoTime"] as! NSNumber).intValue
        photo.config.exportVideoType = WYAExportVideoType(rawValue: WYAExportVideoType.RawValue((map["exportVideoType"] as! NSNumber).intValue))!
        photo.callBackBlock = {(medias, assets) in
            let dic = NSMutableDictionary()
            if medias.count > 0 {
                let list = NSMutableArray()
                for image in medias {
                    let imageData = (image as! UIImage).pngData()
                    let imageString = imageData?.base64EncodedString()
                    list.add(imageString!)
                }
                dic["images"] = list
            }
            if assets.count > 0 {
                self.exportVideo(assets: assets as! [PHAsset], type: WYAExportVideoType(rawValue: WYAExportVideoType.RawValue((map["exportVideoType"] as! NSNumber).intValue))!) { (arr) in
                    dic["videos"] = arr
                }
            }
            result(dic)
        }
        photo.modalPresentationStyle = .fullScreen
        let window = UIApplication.shared.keyWindow
        window?.rootViewController?.present(photo, animated: true, completion: nil)
    }
  }

    func exportVideo(assets:[PHAsset], type:WYAExportVideoType, handle:@escaping (NSMutableArray) -> Void){
        let manager = WYAPhotoBrowserManager.shared()
        let array = NSMutableArray()

        var allCount = 0
        for count in 0..<assets.count {
            let asset = assets[count]
            manager?.exportVideo(for: asset, type: type, complete: { (exportFilePath, error) in
                allCount += 1
                if error == nil {
                    array.add(exportFilePath!)
                }
                if allCount == assets.count {
                    handle(array)
                }
            })
        }

    }
}
