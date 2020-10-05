import 'package:flutter/material.dart';
import 'const.dart' as Const;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Processor',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Text Processor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  TextEditingController _sourceTextController;
  TextEditingController _placeholderController;
  TextEditingController _templateTextController;
  TextEditingController _resultTextController;
  String _splitSeperatorStr;
  String _joinSeperatorStr;

  @override
  void initState() {
    super.initState();
    _sourceTextController = TextEditingController();
    _splitSeperatorStr = Const.DEFAULT_DELIMITOR;
    _placeholderController =
        TextEditingController(text: Const.DEFAULT_PLACEHOLDER);
    _joinSeperatorStr = Const.DEFAULT_DELIMITOR;
    _templateTextController = TextEditingController();
    _resultTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          _topButtonRow(),
          _sourceTextRow(),
          _startPipelineRow(),
          _endPipelineRow(),
          _templateTextRow(),
          _resultTextRow()
        ])));
  }

  Widget _topButtonRow() {
    return Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                  minWidth: 40,
                  height: 40,
                  child: RaisedButton(
                      color: Colors.orange,
                      onPressed: _resetEverything,
                      child: Icon(Icons.replay_outlined))),
            ]));
  }

  Widget _sourceTextRow() {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                    Const.PADDING_EDGEINSETS),
                child: Container(
                    width: MediaQuery.of(context).size.width *
                        Const.TEXTFIELD_WIDTH,
                    height: MediaQuery.of(context).size.height *
                        Const.TEXTFIELD_HEIGHT,
                    child: Card(
                        color: Colors.grey[400],
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width *
                                  Const.CARD_EDGEINSETS),
                          child: TextField(
                            controller: _sourceTextController,
                            onChanged: _textFieldOnChangedHandler,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration.collapsed(
                                hintText: "Source Text"),
                          ),
                        )))),
          ],
        ));
  }

  Widget _startPipelineRow() {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: DropdownButton(
              items: Const.DELIMITOR_LIST,
              hint: Text('Split by'),
              onChanged: (value) => setState(() => _splitSeperatorStr = value),
              value: _splitSeperatorStr,
            )),
            Container(
                width: 140,
                height: 40,
                child: TextField(
                    controller: _placeholderController,
                    onChanged: _textFieldOnChangedHandler,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(prefixText: 'Placeholder: '))),
          ]),
    );
  }

  Widget _endPipelineRow() {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: DropdownButton(
              items: Const.DELIMITOR_LIST,
              onChanged: (value) => setState(() => _joinSeperatorStr = value),
              value: _joinSeperatorStr,
            )),
          ]),
    );
  }

  Widget _templateTextRow() {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                    Const.PADDING_EDGEINSETS),
                child: Container(
                    width: MediaQuery.of(context).size.width *
                        Const.TEXTFIELD_WIDTH,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Card(
                        color: Colors.grey[400],
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width *
                                  Const.CARD_EDGEINSETS),
                          child: TextField(
                            controller: _templateTextController,
                            onChanged: _textFieldOnChangedHandler,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration.collapsed(hintText: 'Template'),
                          ),
                        )))),
          ],
        ));
  }

  Widget _resultTextRow() {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                    Const.PADDING_EDGEINSETS),
                child: Container(
                    width: MediaQuery.of(context).size.width *
                        Const.TEXTFIELD_WIDTH,
                    height: MediaQuery.of(context).size.height *
                        Const.TEXTFIELD_HEIGHT,
                    child: Card(
                        color: Colors.grey[600],
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width *
                                  Const.CARD_EDGEINSETS),
                          child: TextField(
                            controller: _resultTextController,
                            readOnly: true,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Result Text'),
                          ),
                        )))),
          ],
        ));
  }

  void _resetEverything() {
    _setTextField(_sourceTextController, '');
    // _setTextField(_seperatorController, Const.DEFAULT_SEPERATOR);
    _setTextField(_placeholderController, Const.DEFAULT_PLACEHOLDER);
    // _setTextField(_groupDelimitorController, Const.DEFAULT_GROUPDELIMITOR);
    _setTextField(_templateTextController, '');
    _setTextField(_resultTextController, '');
  }

  void _setTextField(
      TextEditingController textEditingController, String textStr) {
    setState(() {
      textEditingController.text = textStr;
      textEditingController.value = TextEditingValue(
        text: textStr,
        selection: TextSelection.fromPosition(
          TextPosition(offset: textStr.length),
        ),
      );
    });
  }

  void _textFieldOnChangedHandler(String value) {
    _processResult();
  }

  void _processResult() {
    List<String> sourceTextList = _seperateSoureText();
    List<String> populateStrList = _populateTemplate(sourceTextList);
    String resultStr = _groupResult(populateStrList);
    _setTextField(_resultTextController, resultStr);
  }

  List<String> _seperateSoureText() {
    String sourceTextStr = _sourceTextController.text;
    return sourceTextStr.split(new RegExp(''));
  }

  List<String> _populateTemplate(List<String> pipelineStrList) {
    String templateStr = _templateTextController.text;
    String placeholderStr = _placeholderController.text;
    List<String> populateStrList = [];
    for (String pipelineStr in pipelineStrList) {
      String resultStr = templateStr.replaceAll(placeholderStr, pipelineStr);
      populateStrList.add(resultStr);
    }
    return populateStrList;
  }

  String _groupResult(List<String> populateStrList) {
    String groupDelimitor = '';
    return populateStrList.join(groupDelimitor);
  }
}
