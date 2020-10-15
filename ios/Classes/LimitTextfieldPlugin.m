#import "LimitTextfieldPlugin.h"
#import "TextfieldFactory.h"
@implementation LimitTextfieldPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  TextfieldFactory* textfieldFactory =
      [[TextfieldFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:textfieldFactory withId:@"plugins.flutter.io/textField"];
}


@end
