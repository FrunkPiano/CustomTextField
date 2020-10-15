import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:limit_textfield/platform_interface.dart';
import 'package:limit_textfield/textfield_method_channel.dart';



class CupertinoLimitTextField implements TextFieldPlatform{
  @override
  Widget build({
    BuildContext context,
    CreationParams creationParams,
    @required TextFieldPlatformCallbacksHandler textFieldPlatformCallbacksHandler,
    TextFieldPlatformCreatedCallback onTextFieldPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  }) {
    return UiKitView(
      viewType: 'plugins.flutter.io/textField',
      onPlatformViewCreated: (int id) {
        if (onTextFieldPlatformCreated == null) {
          return;
        }
        onTextFieldPlatformCreated(
            MethodChannelTextFieldPlatform(id, textFieldPlatformCallbacksHandler));
      },
      gestureRecognizers: gestureRecognizers,
      creationParams: MethodChannelTextFieldPlatform.creationParamsToMap(creationParams),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}