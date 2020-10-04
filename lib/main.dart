import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _varStr1Controller = TextEditingController();
  TextEditingController _templateStrController = TextEditingController();
  TextEditingController _resultStrController = TextEditingController();

  void _renderResult() {
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

  void _copyToClipboard() {
    Clipboard.setData(new ClipboardData(text: _resultStrController.text));
    final snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
      duration: Duration(seconds: 4),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: _renderResult,
                  child: const Text('Render', style: TextStyle(fontSize: 20)),
                ),
                Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _varStr1Controller,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your text here"),
                      ),
                    )),
                Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _templateStrController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your text here"),
                      ),
                    )),
                Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
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
                    onPressed: _copyToClipboard, child: const Icon(Icons.copy)),
              ],
            ),
          ),
        ));
  }
}
