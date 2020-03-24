#import "NativepermissionsPlugin.h"
#if __has_include(<nativepermissions/nativepermissions-Swift.h>)
#import <nativepermissions/nativepermissions-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nativepermissions-Swift.h"
#endif

@implementation NativepermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativepermissionsPlugin registerWithRegistrar:registrar];
}
@end
