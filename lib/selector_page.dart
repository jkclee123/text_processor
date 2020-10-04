import 'package:flutter/material.dart';

Widget selectorPage() {
  return SingleChildScrollView(
      child: new Column(children: <Widget>[
    Card(
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration:
                InputDecoration.collapsed(hintText: "Enter your text here"),
          ),
        )),
  ]));
}
