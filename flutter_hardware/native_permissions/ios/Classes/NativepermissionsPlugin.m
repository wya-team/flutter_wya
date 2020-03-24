#import "NativePermissionsPlugin.h"
#if __has_include(<native_permissions/native_permissions-Swift.h>)
#import <native_permissions/native_permissions-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_permissions-Swift.h"
#endif

@implementation NativePermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativePermissionsPlugin registerWithRegistrar:registrar];
}
@end
