import 'package:flutter/material.dart';
import 'const.dart' as Const;
import 'pipelineControllerGroup.dart';
import 'matchControllerGroup.dart';
import 'findReplaceControllerGroup.dart';

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
  List<Widget> _piplineWidgetList;
  List<PipelineControllerGroup> _pipelineControllerGroupList;
  List<int> _pipelineWidgetIdList;
  int _pipelineWidgetId;

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
    _piplineWidgetList = [];
    _pipelineControllerGroupList = [];
    _pipelineWidgetIdList = [];
    _pipelineWidgetId = 0;
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
          _settingsRow(),
          _addPipelineButtonRow(),
          _pipelineColumn(),
          _templateTextRow(),
          _resultTextRow()
        ])));
  }

// Widget Start
  Widget _topButtonRow() {
    return Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ButtonTheme(
                  minWidth: Const.SQUARE_BTN_LENGTH,
                  height: Const.SQUARE_BTN_LENGTH,
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

  Widget _settingsRow() {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        Const.PADDING_EDGEINSETS),
                    child:
                        Text('Split by: ', style: TextStyle(fontSize: 16.0))),
                Container(
                    child: DropdownButton(
                  items: Const.DELIMITOR_LIST,
                  onChanged: (value) =>
                      _dropdownOnChangedHandler(Const.DROPDOWN_SPLIT, value),
                  value: _splitSeperatorStr,
                )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        Const.PADDING_EDGEINSETS),
                    child: Text('Join by: ', style: TextStyle(fontSize: 16.0))),
                Container(
                    child: DropdownButton(
                  items: Const.DELIMITOR_LIST,
                  onChanged: (value) =>
                      _dropdownOnChangedHandler(Const.DROPDOWN_JOIN, value),
                  value: _joinSeperatorStr,
                )),
              ],
            ),
            Container(
                width: 140,
                height: 40,
                child: TextField(
                    controller: _placeholderController,
                    onChanged: _textFieldOnChangedHandler,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixText: 'Placeholder: ',
                      errorText: _placeholderController.text.isEmpty
                          ? 'Placeholder Required'
                          : null,
                    ))),
          ]),
    );
  }

  Widget _addPipelineButtonRow() {
    return Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  onPressed: () => _addPipelineWidget(Const.PIPELINE_OP_MATCH),
                  child: Text('Match')),
              RaisedButton(
                  onPressed: () =>
                      _addPipelineWidget(Const.PIPELINE_OP_FINDREPLACE),
                  child: Text('Find & Replace')),
            ]));
  }

  Widget _pipelineColumn() {
    return Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
        child: Column(children: _piplineWidgetList));
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

  Widget _pipelineMatchTemplate(
      MatchControllerGroup matchControllerGroup, int pipelineWidgetId) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 240,
                  height: 50,
                  child: TextField(
                      controller: matchControllerGroup.patternController,
                      onChanged: _textFieldOnChangedHandler,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixText: 'Match: ',
                      ))),
              ButtonTheme(
                  minWidth: Const.SQUARE_BTN_LENGTH,
                  height: Const.SQUARE_BTN_LENGTH,
                  child: RaisedButton(
                      onPressed: () =>
                          _removePipelineWidgetHandler(pipelineWidgetId),
                      color: Colors.redAccent,
                      child: Icon(Icons.cancel_outlined)))
            ]));
  }

  Widget _pipelineFindReplaceTemplate(
      FindReplaceControllerGroup findReplaceControllerGroup,
      int pipelineWidgetId) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 240,
                  height: 50,
                  child: TextField(
                      controller: findReplaceControllerGroup.findController,
                      onChanged: _textFieldOnChangedHandler,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixText: 'Find: ',
                      ))),
              Container(
                  width: 240,
                  height: 50,
                  child: TextField(
                      controller: findReplaceControllerGroup.replaceController,
                      onChanged: _textFieldOnChangedHandler,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixText: 'Replace: ',
                      ))),
              ButtonTheme(
                  minWidth: Const.SQUARE_BTN_LENGTH,
                  height: Const.SQUARE_BTN_LENGTH,
                  child: RaisedButton(
                      onPressed: () =>
                          _removePipelineWidgetHandler(pipelineWidgetId),
                      color: Colors.redAccent,
                      child: Icon(Icons.cancel_outlined)))
            ]));
  }
// Widget End

// Function Start
  void _resetEverything() {
    _setTextField(_sourceTextController, '');
    _setTextField(_placeholderController, Const.DEFAULT_PLACEHOLDER);
    _setTextField(_templateTextController, '');
    _setTextField(_resultTextController, '');
    _removeAllPipeline();
  }

  void _setTextField(
      TextEditingController textEditingController, String value) {
    setState(() {
      textEditingController.text = value;
      textEditingController.value = TextEditingValue(
        text: value,
        selection: TextSelection.fromPosition(
          TextPosition(offset: value.length),
        ),
      );
    });
  }

  void _removeAllPipeline() {
    List<int> dummyWidgetIdList =
        _pipelineWidgetIdList.sublist(0, _pipelineWidgetIdList.length);
    for (int pipelineWidgetId in dummyWidgetIdList) {
      _removePipelineWidget(pipelineWidgetId);
    }
  }

  void _addPipelineWidget(String operationCode) {
    PipelineControllerGroup pipelineControllerGroup =
        _getPipelineControllerGroup(operationCode);
    Widget pipelineWidget =
        _getPipelineWidgetTemplate(operationCode, pipelineControllerGroup);
    setState(() => _piplineWidgetList.add(pipelineWidget));
    _pipelineControllerGroupList.add(pipelineControllerGroup);
  }

  Widget _getPipelineWidgetTemplate(
      String operationCode, PipelineControllerGroup pipelineControllerGroup) {
    Widget pipelineWidget;
    if (operationCode == Const.PIPELINE_OP_MATCH) {
      pipelineWidget =
          _pipelineMatchTemplate(pipelineControllerGroup, _pipelineWidgetId);
    } else if (operationCode == Const.PIPELINE_OP_FINDREPLACE) {
      pipelineWidget = _pipelineFindReplaceTemplate(
          pipelineControllerGroup, _pipelineWidgetId);
    }
    _pipelineWidgetIdList.add(_pipelineWidgetId++);
    return pipelineWidget;
  }

  PipelineControllerGroup _getPipelineControllerGroup(String operationCode) {
    if (operationCode == Const.PIPELINE_OP_MATCH) {
      return _createMatchControllerGroup();
    } else if (operationCode == Const.PIPELINE_OP_FINDREPLACE) {
      return __createFindReplaceControllerGroup();
    } else {
      return null;
    }
  }

  PipelineControllerGroup _createMatchControllerGroup() {
    MatchControllerGroup matchControllerGroup = MatchControllerGroup();
    TextEditingController patternController = TextEditingController();
    matchControllerGroup.patternController = patternController;
    return matchControllerGroup;
  }

  PipelineControllerGroup __createFindReplaceControllerGroup() {
    FindReplaceControllerGroup findReplaceControllerGroup =
        FindReplaceControllerGroup();
    TextEditingController findController = TextEditingController();
    TextEditingController replaceController = TextEditingController();
    findReplaceControllerGroup.findController = findController;
    findReplaceControllerGroup.replaceController = replaceController;
    return findReplaceControllerGroup;
  }

  void _removePipelineWidget(int pipelineWidgetId) {
    int rowIndex = _pipelineWidgetIdList.indexOf(pipelineWidgetId);
    _pipelineWidgetIdList.remove(pipelineWidgetId);
    _pipelineControllerGroupList.removeAt(rowIndex);
    setState(() => _piplineWidgetList.removeAt(rowIndex));
  }

  void _textFieldOnChangedHandler(String value) {
    _processResult();
  }

  void _dropdownOnChangedHandler(String dropdownId, String value) {
    if (dropdownId == Const.DROPDOWN_SPLIT) {
      setState(() => _splitSeperatorStr = value);
    } else if (dropdownId == Const.DROPDOWN_JOIN) {
      setState(() => _joinSeperatorStr = value);
    }
    _processResult();
  }

  void _removePipelineWidgetHandler(int pipelineWidgetId) {
    _removePipelineWidget(pipelineWidgetId);
    _processResult();
  }

  void _processResult() {
    List<String> sourceTextList = _seperateSoureText();
    List<String> populateStrList = _populateTemplate(sourceTextList);
    String resultStr = _joinResult(populateStrList);
    _setTextField(_resultTextController, resultStr);
  }

  List<String> _seperateSoureText() {
    String sourceTextStr = _sourceTextController.text;
    return sourceTextStr.split(new RegExp(_splitSeperatorStr));
  }

  List<String> _populateTemplate(List<String> pipelineStrList) {
    String templateStr = _templateTextController.text;
    if (templateStr.isEmpty) {
      return pipelineStrList;
    }
    String placeholderStr = _placeholderController.text;
    List<String> populateStrList = [];
    for (String pipelineStr in pipelineStrList) {
      String resultStr = templateStr.replaceAll(placeholderStr, pipelineStr);
      populateStrList.add(resultStr);
    }
    return populateStrList;
  }

  String _joinResult(List<String> populateStrList) {
    return populateStrList.join(_joinSeperatorStr);
  }
}
