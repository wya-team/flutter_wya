#import "NativeGalleryPlugin.h"
#if __has_include(<native_gallery/native_gallery-Swift.h>)
#import <native_gallery/native_gallery-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_gallery-Swift.h"
#endif

@implementation NativeGalleryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeGalleryPlugin registerWithRegistrar:registrar];
}
@end
