import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:limit_textfield/limit_textfield.dart';


class CustomTextFieldController {

  CustomTextFieldController({String text}) {
    initText = text;
    otherController = TextEditingController(text: text);
  }

  TextEditingController otherController;
  TextFieldController iosController;

  String initText;

  String get text {
    if (Platform.isIOS) {
      return iosController?.currentText ?? '';
    } else {
      return otherController.text;
    }
  }

  set selection(TextSelection selection) {
    if(Platform.isIOS) {

    } else {
      otherController.selection = selection;
    }
  }

  set text(String text) {
    if(Platform.isIOS) {
      iosController?.setText(text);
    } else {
      otherController.text = text;
    }
  }


}