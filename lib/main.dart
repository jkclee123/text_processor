import 'package:flutter/material.dart';
import 'const.dart' as Const;
import 'package:text_processor/pipelineGroup.dart';
import 'package:text_processor/pipelineRowController.dart';
import 'package:text_processor/matchPipelineRowController.dart';
import 'package:text_processor/findReplacePipelineRowController.dart';

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
  PipelineGroup _matchPipelineGroup;
  PipelineGroup _findReplacePipelineGroup;

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
    _matchPipelineGroup = PipelineGroup();
    _findReplacePipelineGroup = PipelineGroup();
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
          _pipelineColumn(),
          _templateTextRow(),
          _resultTextRow()
        ])));
  }

// Widget Start
  Widget _topButtonRow() {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
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
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
      child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: Card(
              color: Colors.grey[400],
              child: Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * Const.CARD_EDGEINSETS),
                child: TextField(
                  controller: _sourceTextController,
                  onChanged: (value) => _processResult(),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration:
                      InputDecoration.collapsed(hintText: "Source Text"),
                ),
              ))),
    );
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
                  onChanged: (value) {
                    setState(() => _splitSeperatorStr = value);
                    _processResult();
                  },
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
                  onChanged: (value) {
                    setState(() => _joinSeperatorStr = value);
                    _processResult();
                  },
                  value: _joinSeperatorStr,
                )),
              ],
            ),
            Container(
                width: 140,
                height: 40,
                child: TextField(
                    controller: _placeholderController,
                    onChanged: (value) => _processResult(),
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

  Widget _pipelineColumn() {
    return Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _matchPipelineColumn(),
              _findReplacePipelineColumn()
            ]));
  }

  Widget _matchPipelineColumn() {
    return Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(children: <Widget>[
              RaisedButton(
                  onPressed: () => _addPipelineWidget(
                      Const.PIPELINE_OP_MATCH, _matchPipelineGroup),
                  child: Text('Match')),
              Column(children: _matchPipelineGroup.widgetList)
            ])));
  }

  Widget _findReplacePipelineColumn() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Column(children: <Widget>[
          RaisedButton(
              onPressed: () => _addPipelineWidget(
                  Const.PIPELINE_OP_FINDREPLACE, _findReplacePipelineGroup),
              child: Text('Find & Replace')),
          Column(children: _findReplacePipelineGroup.widgetList)
        ]));
  }

  Widget _templateTextRow() {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
      child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: Card(
              color: Colors.grey[400],
              child: Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * Const.CARD_EDGEINSETS),
                child: TextField(
                  controller: _templateTextController,
                  onChanged: (value) => _processResult(),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration.collapsed(hintText: "Template"),
                ),
              ))),
    );
  }

  Widget _resultTextRow() {
    return Padding(
      padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
      child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: Card(
              color: Colors.grey[600],
              child: Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * Const.CARD_EDGEINSETS),
                child: TextField(
                  controller: _resultTextController,
                  readOnly: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration:
                      InputDecoration.collapsed(hintText: "Result Text"),
                ),
              ))),
    );
  }

  Widget _pipelineMatchTemplate(
      MatchPipelineRowController rowController, int widgetId) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
          padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * Const.PADDING_EDGEINSETS),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        Const.PADDING_EDGEINSETS),
                    child: Column(children: [
                      Text('Contains'),
                      Container(
                        child: Checkbox(
                            onChanged: (value) {
                              setState(() => rowController.contains =
                                  rowController.matchedText ? true : value);
                              _processResult();
                            },
                            value: rowController.contains),
                      )
                    ])),
                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        Const.PADDING_EDGEINSETS),
                    child: Column(children: [
                      Text('Matched Text'),
                      Container(
                        child: Checkbox(
                            onChanged: (value) {
                              setState(() => rowController.contains =
                                  value ? true : rowController.contains);
                              setState(() => rowController.matchedText = value);
                              _processResult();
                            },
                            value: rowController.matchedText),
                      )
                    ])),
                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        Const.PADDING_EDGEINSETS),
                    child: Container(
                        width: 240,
                        height: 50,
                        child: TextField(
                            controller: rowController.patternController,
                            onChanged: (value) => _processResult(),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixText: 'Match: ',
                            )))),
                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                        Const.PADDING_EDGEINSETS),
                    child: ButtonTheme(
                        minWidth: Const.SQUARE_BTN_LENGTH,
                        height: Const.SQUARE_BTN_LENGTH,
                        child: RaisedButton(
                            onPressed: () => _removePipelineWidgetHandler(
                                Const.PIPELINE_OP_MATCH, widgetId),
                            color: Colors.redAccent,
                            child: Icon(Icons.cancel_outlined))))
              ]));
    });
  }

  Widget _pipelineFindReplaceTemplate(
      FindReplacePipelineRowController rowController, int widgetId) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                      Const.PADDING_EDGEINSETS),
                  child: Container(
                      width: 240,
                      height: 50,
                      child: TextField(
                          controller: rowController.findController,
                          onChanged: (value) => _processResult(),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixText: 'Find: ',
                          )))),
              Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                      Const.PADDING_EDGEINSETS),
                  child: Container(
                      width: 240,
                      height: 50,
                      child: TextField(
                          controller: rowController.replaceController,
                          onChanged: (value) => _processResult(),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixText: 'Replace: ',
                          )))),
              Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                      Const.PADDING_EDGEINSETS),
                  child: ButtonTheme(
                      minWidth: Const.SQUARE_BTN_LENGTH,
                      height: Const.SQUARE_BTN_LENGTH,
                      child: RaisedButton(
                          onPressed: () => _removePipelineWidgetHandler(
                              Const.PIPELINE_OP_FINDREPLACE, widgetId),
                          color: Colors.redAccent,
                          child: Icon(Icons.cancel_outlined))))
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
    // List<int> dummyMatchWidgetIdList = _matchPipelineWidgetIdList.sublist(
    //     0, _matchPipelineWidgetIdList.length);
    // for (int pipelineWidgetId in dummyMatchWidgetIdList) {
    //   _removePipelineWidget(pipelineWidgetId);
    // }
  }

  void _addPipelineWidget(String operationCode, PipelineGroup pipelineGroup) {
    PipelineRowController pipelineRowController =
        _getpipelineRowController(operationCode);
    Widget pipelineWidget = _getPipelineWidgetTemplate(
        operationCode, pipelineGroup, pipelineRowController);
    pipelineGroup.rowControllerList.add(pipelineRowController);
    setState(() => pipelineGroup.widgetList.add(pipelineWidget));
  }

  PipelineRowController _getpipelineRowController(String operationCode) {
    if (operationCode == Const.PIPELINE_OP_MATCH) {
      return MatchPipelineRowController();
    } else if (operationCode == Const.PIPELINE_OP_FINDREPLACE) {
      return FindReplacePipelineRowController();
    } else {
      return null;
    }
  }

  Widget _getPipelineWidgetTemplate(
      String operationCode,
      PipelineGroup pipelineGroup,
      PipelineRowController pipelineRowController) {
    Widget pipelineWidget;
    if (operationCode == Const.PIPELINE_OP_MATCH) {
      pipelineWidget = _pipelineMatchTemplate(
          pipelineRowController, pipelineGroup.widgetIdCounter);
    } else if (operationCode == Const.PIPELINE_OP_FINDREPLACE) {
      pipelineWidget = _pipelineFindReplaceTemplate(
          pipelineRowController, pipelineGroup.widgetIdCounter);
    }
    pipelineGroup.widgetIdList.add(pipelineGroup.widgetIdCounter++);
    return pipelineWidget;
  }

  void _removePipelineWidget(String operationCode, int pipelineWidgetId) {
    PipelineGroup pipelineGroup;
    if (operationCode == Const.PIPELINE_OP_MATCH) {
      pipelineGroup = _matchPipelineGroup;
    } else if (operationCode == Const.PIPELINE_OP_FINDREPLACE) {
      pipelineGroup = _findReplacePipelineGroup;
    } else {
      return;
    }
    int rowIndex = pipelineGroup.widgetIdList.indexOf(pipelineWidgetId);
    pipelineGroup.widgetIdList.remove(pipelineWidgetId);
    pipelineGroup.rowControllerList.removeAt(rowIndex);
    setState(() => pipelineGroup.widgetList.removeAt(rowIndex));
  }

  void _removePipelineWidgetHandler(
      String operationCode, int pipelineWidgetId) {
    _removePipelineWidget(operationCode, pipelineWidgetId);
    _processResult();
  }

  void _processResult() {
    List<String> sourceStrList = _seperateSoureText();
    List<String> matchStrList = _matchSourceText(sourceStrList);
    List<String> populateStrList = _populateTemplate(matchStrList);
    String resultStr = _joinResult(populateStrList);
    _setTextField(_resultTextController, resultStr);
  }

  List<String> _seperateSoureText() {
    String sourceStr = _sourceTextController.text;
    return sourceStr.split(new RegExp(_splitSeperatorStr));
  }

  List<String> _matchSourceText(List<String> sourceStrList) {
    List<MatchPipelineRowController> rowControllerList =
        _matchPipelineGroup.rowControllerList;
    for (MatchPipelineRowController rowController in rowControllerList) {
      List<String> matchStrList = [];
      for (String sourceStr in sourceStrList) {
        if (sourceStr
                .contains(new RegExp(rowController.patternController.text)) ==
            rowController.contains) {
          // sourceStr.allMatches(string)
        }
      }
    }
  }

  List<String> _populateTemplate(List<String> pipelineStrList) {
    String templateStr = _templateTextController.text;
    if (templateStr.isEmpty) {
      return pipelineStrList;
    }
    String placeholderStr = _placeholderController.text;
    List<String> populateStrList = [];
    for (String pipelineStr in pipelineStrList) {
      String populateStr = templateStr.replaceAll(placeholderStr, pipelineStr);
      populateStrList.add(populateStr);
    }
    return populateStrList;
  }

  String _joinResult(List<String> populateStrList) {
    return populateStrList.join(_joinSeperatorStr);
  }
}
