#import "NextAlarmPlugin.h"
#if __has_include(<next_alarm/next_alarm-Swift.h>)
#import <next_alarm/next_alarm-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "next_alarm-Swift.h"
#endif

@implementation NextAlarmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNextAlarmPlugin registerWithRegistrar:registrar];
}
@end
