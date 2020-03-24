#import "NativeDeviceInfoPlugin.h"
#if __has_include(<native_device_info/native_device_info-Swift.h>)
#import <native_device_info/native_device_info-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_device_info-Swift.h"
#endif

@implementation NativeDeviceInfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeDeviceInfoPlugin registerWithRegistrar:registrar];
}
@end
