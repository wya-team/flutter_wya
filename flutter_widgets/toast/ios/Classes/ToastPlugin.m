#import "ToastPlugin.h"
#if __has_include(<toast/toast-Swift.h>)
#import <toast/toast-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "toast-Swift.h"
#endif

@implementation ToastPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftToastPlugin registerWithRegistrar:registrar];
}
@end
