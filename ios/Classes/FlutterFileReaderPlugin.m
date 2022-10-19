#import "FlutterFileReaderPlugin.h"

@implementation FlutterFileReaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFileReaderPlugin registerWithRegistrar:registrar];
}
@end
