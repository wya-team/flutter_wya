#import "NativeRecordPlugin.h"
#if __has_include(<native_record/native_record-Swift.h>)
#import <native_record/native_record-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_record-Swift.h"
#endif

@implementation NativeRecordPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeRecordPlugin registerWithRegistrar:registrar];
}
@end
