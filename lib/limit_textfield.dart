import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:limit_textfield/platform_interface.dart';
import 'package:limit_textfield/textfield_ios.dart';

typedef void TextFieldCreatedCallback(TextFieldController controller);

typedef void TextChangedCallback(String text);

class LimitTextField extends StatefulWidget {
  LimitTextField({
    Key key,
    this.onTextFieldCreated,
    this.maxLength,
    this.gestureRecognizers,
    this.debuggingEnabled = false,
    this.gestureNavigationEnabled = false,
    this.onChanged,
    this.hintText,
    this.borderColor,
    this.borderWidth,
    this.cornerRadius,
    this.fontSize,
  })  : super(key: key);

  static TextFieldPlatform _platform;

  final int maxLength;
  final String hintText;

  final int fontSize;

  final String borderColor;
  final double cornerRadius;
  final double borderWidth;

  final bool debuggingEnabled;
  final bool gestureNavigationEnabled;
  String currentText = '';
  static set platform(TextFieldPlatform platform) {
    _platform = platform;
  }

  static TextFieldPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = CupertinoLimitTextField();
          break;
        case TargetPlatform.iOS:
          _platform = CupertinoLimitTextField();
          break;
        default:
          throw UnsupportedError(
              "Trying to use the default textField implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform;
  }

  final TextFieldCreatedCallback onTextFieldCreated;

  final TextChangedCallback onChanged;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State<StatefulWidget> createState() => _TextFieldState();

}

class _TextFieldState extends State<LimitTextField> {
  final Completer<TextFieldController> _controller =
  Completer<TextFieldController>();

  _PlatformCallbacksHandler _platformCallbacksHandler;

  @override
  Widget build(BuildContext context) {
    return LimitTextField.platform.build(
      context: context,
      onTextFieldPlatformCreated: _onTextFieldPlatformCreated,
      textFieldPlatformCallbacksHandler: _platformCallbacksHandler,
      gestureRecognizers: widget.gestureRecognizers,
      creationParams: _creationParamsfromWidget(widget),
    );
  }

  @override
  void initState() {
    super.initState();
    _platformCallbacksHandler = _PlatformCallbacksHandler(widget);
  }

  void _onTextFieldPlatformCreated(TextFieldPlatformController textFieldPlatform) {
    final TextFieldController controller =
    TextFieldController._(widget, textFieldPlatform, _platformCallbacksHandler);
    _controller.complete(controller);
    if (widget.onTextFieldCreated != null) {
      widget.onTextFieldCreated(controller);
    }
  }

}

CreationParams _creationParamsfromWidget(LimitTextField widget) {
  return CreationParams(
    maxLength: widget.maxLength,
    hintText: widget.hintText,
    borderWidth: widget.borderWidth,
    borderColor: widget.borderColor,
    cornerRadius: widget.cornerRadius,
    fontSize: widget.fontSize,

  );
}

TextFieldSettings _textFieldSettingsFromWidget(LimitTextField widget) {
  return TextFieldSettings(
    debuggingEnabled: widget.debuggingEnabled,
    gestureNavigationEnabled: widget.gestureNavigationEnabled,
  );
}

class _PlatformCallbacksHandler implements TextFieldPlatformCallbacksHandler {
  _PlatformCallbacksHandler(this._widget);

  LimitTextField _widget;

  @override
  void onChanged(String text) {
    _widget.currentText = text;
    if(_widget.onChanged != null) {
      _widget.onChanged(text);
    }
  }

}

class TextFieldController {
  TextFieldController._(
      this._widget,
      this._textFieldPlatformController,
      this._platformCallbacksHandler,
      ) : assert(_textFieldPlatformController != null) {
    _settings = _textFieldSettingsFromWidget(_widget);
  }

  final TextFieldPlatformController _textFieldPlatformController;

  final _PlatformCallbacksHandler _platformCallbacksHandler;

  TextFieldSettings _settings;

  LimitTextField _widget;

  String get currentText {
    return _widget.currentText;
  }

  Future<String> text() {
    return _textFieldPlatformController.text();
  }

  Future<void> setText(String text) {
    _widget.currentText = text;
    return _textFieldPlatformController.setText(text);
  }

  Future<void> resignFirstResponder() {
    return _textFieldPlatformController.resignFirstResponder();
  }
}