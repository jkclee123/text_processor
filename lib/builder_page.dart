import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget builderPage(
    TextEditingController _varStr1Controller,
    TextEditingController _templateStrController,
    TextEditingController _resultStrController) {
  return SingleChildScrollView(
    child: new Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () => _buildResult(
              _varStr1Controller, _templateStrController, _resultStrController),
          child: const Text('Build', style: TextStyle(fontSize: 20)),
        ),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _varStr1Controller,
                decoration:
                    InputDecoration.collapsed(hintText: "Enter your text here"),
              ),
            )),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _templateStrController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enter your text here"),
              ),
            )),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                focusNode: FocusNode(),
                enableInteractiveSelection: false,
                enabled: false,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _resultStrController,
              ),
            )),
        RaisedButton(
            onPressed: () => _copyToClipboard(_resultStrController),
            child: const Icon(Icons.copy)),
      ],
    ),
  );
}

void _copyToClipboard(TextEditingController _resultStrController) {
  Clipboard.setData(new ClipboardData(text: _resultStrController.text));
}

void _buildResult(
    TextEditingController _varStr1Controller,
    TextEditingController _templateStrController,
    TextEditingController _resultStrController) {
  String varStr1 = _varStr1Controller.text;
  String templateStr = _templateStrController.text;
  if (varStr1.isEmpty || templateStr.isEmpty) {
    return;
  }

  List<String> varStr1List = varStr1.split("\n");
  String resultStr = "";
  int counter = 1;
  for (String rowStr in varStr1List) {
    String resultRowStr = templateStr
        .replaceAll("##1", rowStr)
        .replaceAll("##c", counter.toString());
    resultStr += resultRowStr + "\n";
    counter += 1;
  }
  resultStr = resultStr.substring(0, resultStr.length - 1);

  _resultStrController.text = resultStr;
  _resultStrController.value = TextEditingValue(
    text: resultStr,
    selection: TextSelection.fromPosition(
      TextPosition(offset: resultStr.length),
    ),
  );
}
