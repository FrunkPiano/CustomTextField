
import 'package:flutter/material.dart';
import 'package:limit_textfield/custom_text_field.dart';
import 'package:limit_textfield/custom_text_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  CustomTextFieldController _controller = CustomTextFieldController();

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
          child: CustomTextField(
            maxLength: 10,
            controller: _controller,
            borderColor: '#000000',
            borderWidth: 2,
            onChanged: (String text){
              print(text);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _controller.text = 'fuck';
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }


}
