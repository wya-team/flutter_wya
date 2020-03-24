#import "DatePlugin.h"
#if __has_include(<date/date-Swift.h>)
#import <date/date-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "date-Swift.h"
#endif

@implementation DatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDatePlugin registerWithRegistrar:registrar];
}
@end
