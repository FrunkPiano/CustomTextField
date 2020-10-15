//
//  TextfieldFactory.m
//  limit_textfield
//
//  Created by mac on 2020/9/11.
//

#import "TextfieldFactory.h"
#import "LimitTextfield.h"
@implementation TextfieldFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    TextfieldController *textfield = [[TextfieldController alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return textfield;
}


@end

@interface TextfieldController()

@end

@implementation TextfieldController {
  LimitTextfield* _textField;
  int64_t _viewId;
  FlutterMethodChannel* _channel;
    NSString *_text;
    int _maxCount;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        _viewId = viewId;

        NSString* channelName = [NSString stringWithFormat:@"plugins.flutter.io/textField_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            [weakSelf onMethodCall:call result:result];
        }];
        _textField = [[LimitTextfield alloc] initWithFrame:frame];
        _textField.delegate = self;
        _textField.placeholder = args[@"hintText"];
        _textField.font = [UIFont systemFontOfSize:[args[@"fontSize"] intValue]];
        _textField.layer.borderColor = [[self colorWithHexString:args[@"borderColor"]] CGColor];
        _textField.layer.borderWidth = [args[@"borderWidth"] floatValue];
        [_textField addTarget:self action:@selector(TextFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _maxCount = [args[@"maxLength"] intValue];
        
    }
    return self;
}

- (UIView*)view {
  return _textField;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   if ([[call method] isEqualToString:@"text"]) {
      [self onCurrentText:call result:result];
   } else if([[call method] isEqualToString:@"resignFirstResponder"]) {
       [self onResignFirstResponder:call result:result];
   } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)onCurrentText:(FlutterMethodCall*)call result:(FlutterResult)result {
    _text = _textField.text;
    result(_text);
}

- (void)onResignFirstResponder:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_textField resignFirstResponder];
    result(nil);
}

- (void)onUpdateSettings:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* error = [self applySettings:[call arguments]];
  if (error == nil) {
    result(nil);
    return;
  }
  result([FlutterError errorWithCode:@"updateSettings_failed" message:error details:nil]);
}

// Returns nil when successful, or an error message when one or more keys are unknown.
- (NSString*)applySettings:(NSDictionary<NSString*, id>*)settings {
  NSMutableArray<NSString*>* unknownKeys = [[NSMutableArray alloc] init];
  for (NSString* key in settings) {
    if ([key isEqualToString:@"jsMode"]) {
//      NSNumber* mode = settings[key];
//      [self updateJsMode:mode];
    } else {
      [unknownKeys addObject:key];
    }
  }
  if ([unknownKeys count] == 0) {
    return nil;
  }
  return [NSString stringWithFormat:@"textfield_flutter: unknown setting keys: {%@}",
                                    [unknownKeys componentsJoinedByString:@", "]];
}

- (void)TextFieldDidChanged:(UITextField *)textField {
    if (textField.text.length > _maxCount) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:_maxCount];
        textField.text = [textField.text substringToIndex:range.location];
    }
    [_channel invokeMethod:@"onChanged" arguments:@{@"text" : textField.text}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (UIColor *) colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
