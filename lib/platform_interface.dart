import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


abstract class TextFieldPlatformCallbacksHandler {
  void onChanged(String text);
}

abstract class TextFieldPlatformController {
  TextFieldPlatformController(TextFieldPlatformCallbacksHandler handler);

  Future<String> text() {
    throw UnimplementedError(
        "TextField currentText is not implemented on the current platform");
  }

  Future<void> setText(String text) {
    throw UnimplementedError(
        "TextField currentText is not implemented on the current platform");
  }
  Future<void> resignFirstResponder() {
    throw UnimplementedError(
        "TextField resignFirstResponder is not implemented on the current platform");
  }
}

class TextFieldSettings {
  TextFieldSettings({
    this.debuggingEnabled,
    this.gestureNavigationEnabled,
  });

  /// Whether to enable the platform's webview content debugging tools.
  ///
  /// See also: [WebView.debuggingEnabled].
  final bool debuggingEnabled;


  /// Whether to allow swipe based navigation in iOS.
  ///
  /// See also: [WebView.gestureNavigationEnabled]
  final bool gestureNavigationEnabled;

}



class CreationParams {
  CreationParams({
    this.maxLength,
    this.hintText,
    this.borderColor,
    this.borderWidth,
    this.cornerRadius,
    this.fontSize,
  });
  final int maxLength;
  final String hintText;
  final int fontSize;

  final String borderColor;
  final double cornerRadius;
  final double borderWidth;
}

typedef TextFieldPlatformCreatedCallback = void Function(
    TextFieldPlatformController textFieldPlatformController);

abstract class TextFieldPlatform {
  Widget build({
    BuildContext context,
    CreationParams creationParams,
    @required TextFieldPlatformCallbacksHandler textFieldPlatformCallbacksHandler,
    TextFieldPlatformCreatedCallback onTextFieldPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
  });

}