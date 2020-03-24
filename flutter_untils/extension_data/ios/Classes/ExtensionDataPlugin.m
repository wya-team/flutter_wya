#import "ExtensionDataPlugin.h"
#if __has_include(<extension_data/extension_data-Swift.h>)
#import <extension_data/extension_data-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "extension_data-Swift.h"
#endif

@implementation ExtensionDataPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftExtensionDataPlugin registerWithRegistrar:registrar];
}
@end
