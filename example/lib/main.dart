import 'dart:async';

import 'package:flutter/material.dart';
import 'package:limit_textfield/limit_textfield.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextFieldController _controller;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: 100,
          height: 30,
          child: LimitTextField(
            maxLength: 10,
            onTextFieldCreated: (TextFieldController textFieldController) {
              _controller = textFieldController;
            },
            hintText: '请输入手机号',
            borderColor: '#000000',
            borderWidth: 2,
            fontSize: 20,
            onChanged: (String text){
              print(text);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _controller.resignFirstResponder();
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }


}
