import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'limit_textfield.dart';
import 'custom_text_controller.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField({
    this.width,
    this.height,
    this.maxLength,
    this.borderColor,
    this.borderWidth,
    this.onTextFieldCreated,
    this.onChanged,
    this.controller,
    this.style,
    this.inputFormatters,
    this.keyboardAppearance,
    this.keyboardType,
    this.decoration,
    this.autofocus,
    this.maxLines,
    this.onEditingComplete,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.minLines,
  });

  final VoidCallback onEditingComplete;
  final int maxLines;
  final int minLines;
  final double width;
  final double height;
  final CustomTextFieldController controller;
  final int maxLength;
  final String borderColor;
  final double borderWidth;
  final TextFieldCreatedCallback onTextFieldCreated;
  final TextChangedCallback onChanged;

  final bool autofocus;
  final TextStyle style;
  final List<TextInputFormatter> inputFormatters;
  final Brightness keyboardAppearance;
  final TextInputType keyboardType;
  final InputDecoration decoration;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Container(
        // width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            LimitTextField(
              onTextFieldCreated: (TextFieldController tController) {
                tController.setText(controller.initText);
                controller.iosController = tController;
                onTextFieldCreated(tController);
              },
              onChanged: onChanged,
              maxLength: maxLength,
              hintText: decoration.hintText,
              fontSize: style.fontSize.toInt(),
            ),
            if (decoration.suffixIcon != null)
              Positioned(
                right: 20,
                child: decoration.suffixIcon,
              )
          ],
        ),
      );
    } else {
      return TextField(
        onEditingComplete: onEditingComplete,
        maxLines: maxLines,
        maxLength: maxLength,
        controller: controller.otherController,
        style: style,
        inputFormatters: inputFormatters,
        keyboardAppearance: keyboardAppearance,
        keyboardType: keyboardType,
        decoration: decoration,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onTap: onTap,
        minLines: minLines,
      );
    }

  }
}