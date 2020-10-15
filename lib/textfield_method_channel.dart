import 'package:flutter/services.dart';
import 'package:limit_textfield/platform_interface.dart';

class MethodChannelTextFieldPlatform implements TextFieldPlatformController {

  MethodChannelTextFieldPlatform(int id, this._platformCallbacksHandler)
      : assert(_platformCallbacksHandler != null),
        _channel = MethodChannel('plugins.flutter.io/textField_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final TextFieldPlatformCallbacksHandler _platformCallbacksHandler;

  final MethodChannel _channel;

  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onChanged':
        print('onChanged');
        _platformCallbacksHandler.onChanged(call.arguments['text']);
        return null;
    }
    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  @override
  Future<String> text() {
    return _channel.invokeMethod<String>('text');
  }

  @override
  Future<void> resignFirstResponder() {
    return _channel.invokeMethod<void>('resignFirstResponder');
  }

  static Map<String, dynamic> creationParamsToMap(
      CreationParams creationParams) {
    return <String, dynamic>{
      'maxLength': creationParams.maxLength,
      'hintText': creationParams.hintText,
      'borderColor': creationParams.borderColor,
      'borderWidth': creationParams.borderWidth,
      'cornerRadius': creationParams.cornerRadius,
      'fontSize': creationParams.fontSize,
    };
  }

}