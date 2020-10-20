import 'package:flutter/material.dart';
import 'package:text_processor/controller_group/controller_group.dart';
import 'package:text_processor/controller_group/findreplace_controller_group.dart';
import 'package:text_processor/controller_group/match_controller_group.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:text_processor/config/style_config.dart';
import 'package:text_processor/config/const.dart' as Const;
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ThemeController _themeController;
  GlobalKey<AnimatedListState> _animatedListKey;
  TextEditingController _sourceStrController;
  TextEditingController _templateStrController;
  TextEditingController _splitSeparatorController;
  TextEditingController _joinSeparatorController;
  TextEditingController _placeholderController;
  bool _distinct;
  TextEditingController _resultStrController;
  List<ControllerGroup> _controllerGroupList;

  @override
  void initState() {
    super.initState();
    _animatedListKey = GlobalKey<AnimatedListState>();
    _sourceStrController = TextEditingController();
    _templateStrController = TextEditingController();
    _splitSeparatorController =
        TextEditingController(text: Const.default_split_separator);
    _joinSeparatorController =
        TextEditingController(text: Const.default_join_separator);
    _placeholderController =
        TextEditingController(text: Const.default_placeholder);
    _distinct = false;
    _resultStrController = TextEditingController();
    _controllerGroupList = <ControllerGroup>[];
  }

  @override
  Widget build(BuildContext context) {
    _themeController = ThemeProvider.controllerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        StyleConfig().init(constraints);
        return _mainWidget();
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: _resultStrController.text)),
          elevation: StyleConfig.elevation,
          child: Icon(Icons.copy)),
    );
  }

  Widget _mainWidget() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: StyleConfig.edgeInsets),
      children: <Widget>[
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: _settingsBtnList(),
        ),
        IntrinsicHeight(
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: StyleConfig.flexDirection,
            children: _sourceTextFieldList(),
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: _settingsInputList(),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.only(top: StyleConfig.edgeInsets),
          child: AnimatedList(
            key: _animatedListKey,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            initialItemCount: _controllerGroupList.length,
            itemBuilder: (context, index, animation) {
              return _pipelineRow(context, index, animation);
            },
          ),
        ),
        _resultTextField()
      ],
    );
  }

  List<Widget> _sourceTextFieldList() {
    return [
      Expanded(
          child: Container(
              padding: EdgeInsets.all(StyleConfig.edgeInsets),
              constraints:
                  BoxConstraints(maxHeight: StyleConfig.textFieldHeight),
              child: Card(
                  elevation: StyleConfig.elevation,
                  child: Padding(
                      padding: EdgeInsets.all(StyleConfig.edgeInsets),
                      child: TextField(
                        controller: _sourceStrController,
                        onChanged: (value) => _processResult(),
                        minLines: StyleConfig.textFieldMinLines,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Source Text",
                            suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _sourceStrController.clear();
                                  _processResult();
                                })),
                      ))))),
      Expanded(
          child: Container(
              padding: EdgeInsets.all(StyleConfig.edgeInsets),
              constraints:
                  BoxConstraints(maxHeight: StyleConfig.textFieldHeight),
              child: Card(
                  elevation: StyleConfig.elevation,
                  child: Padding(
                    padding: EdgeInsets.all(StyleConfig.edgeInsets),
                    child: TextField(
                      controller: _templateStrController,
                      onChanged: (value) => _processResult(),
                      minLines: StyleConfig.textFieldMinLines,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Template",
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _templateStrController.clear();
                                _processResult();
                              })),
                    ),
                  ))))
    ];
  }

  List<Widget> _settingsBtnList() {
    return [
      Padding(
          padding: EdgeInsets.all(StyleConfig.edgeInsets),
          child: RaisedButton(
            color: Colors.amberAccent[400],
            child: Icon(Icons.lightbulb_outline),
            onPressed: _themeController.nextTheme,
          )),
      Padding(
          padding: EdgeInsets.all(StyleConfig.edgeInsets),
          child: RaisedButton(
            color: Colors.redAccent,
            child: Icon(Icons.clear_all_outlined),
            onPressed: _resetEverything,
          )),
      Padding(
          padding: EdgeInsets.all(StyleConfig.edgeInsets),
          child: RaisedButton(
            child: Icon(Icons.refresh_outlined),
            onPressed: _processResult,
          )),
    ];
  }

  List<Widget> _settingsInputList() {
    return [
      Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        width: StyleConfig.singleLineInputWidth,
        child: TextField(
            controller: _splitSeparatorController,
            onChanged: (value) => _processResult(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixText: 'Split: ',
            )),
      ),
      Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        width: StyleConfig.singleLineInputWidth,
        child: TextField(
            controller: _joinSeparatorController,
            onChanged: (value) => _processResult(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixText: 'Join: ',
            )),
      ),
      Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        width: StyleConfig.singleLineInputWidth,
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
            )),
      ),
      Padding(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        child: Column(
          children: [
            Text('Distinct'),
            Switch(
                value: _distinct,
                onChanged: (value) {
                  setState(() => _distinct = value);
                  _processResult();
                })
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.all(StyleConfig.edgeInsets),
          child: RaisedButton(
            child: Text(Const.pipeline_match),
            onPressed: () => _addPipeline(Const.pipeline_match),
          )),
      Padding(
          padding: EdgeInsets.all(StyleConfig.edgeInsets),
          child: RaisedButton(
            child: Text(Const.pipeline_findreplace),
            onPressed: () => _addPipeline(Const.pipeline_findreplace),
          )),
    ];
  }

  Widget _pipelineRow(
      BuildContext context, int index, Animation<double> animation) {
    if (_controllerGroupList.length <= index) return null;
    ControllerGroup controllerGroup = _controllerGroupList[index];
    Widget tile = _getPipelineTile(controllerGroup, index);

    return SizeTransition(
      sizeFactor: animation,
      child: tile,
    );
  }

  Widget _getPipelineTile(ControllerGroup controllerGroup, int index) {
    if (controllerGroup is MatchControllerGroup) {
      return _getMatchPipelineTile(controllerGroup, index);
    } else if (controllerGroup is FindReplaceControllerGroup) {
      return _getFindReplacePipelineTile(controllerGroup, index);
    }
    return null;
  }

  Widget _getMatchPipelineTile(
      MatchControllerGroup controllerGroup, int index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ListTile(
        title: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(StyleConfig.edgeInsets),
              child: Column(
                children: [
                  Text('Contains'),
                  Switch(
                      value: controllerGroup.contains,
                      onChanged: (value) {
                        setState(() => controllerGroup.contains = value);
                        _processResult();
                      })
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(StyleConfig.edgeInsets),
              child: Column(
                children: [
                  Text('Match Case'),
                  Switch(
                      value: controllerGroup.caseSensitive,
                      onChanged: (value) {
                        setState(() => controllerGroup.caseSensitive = value);
                        _processResult();
                      })
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(StyleConfig.edgeInsets),
              width: StyleConfig.singleLineInputWidth,
              child: TextField(
                  controller: controllerGroup.patternController,
                  onChanged: (value) => _processResult(),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixText: 'Match: ',
                  )),
            ),
          ],
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: StyleConfig.edgeInsets),
          child: RaisedButton(
            color: Colors.redAccent,
            child: Icon(Icons.clear),
            onPressed: () {
              _removePipeline(index);
              _processResult();
            },
          ),
        ),
      );
    });
  }

  Widget _getFindReplacePipelineTile(
      FindReplaceControllerGroup controllerGroup, int index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ListTile(
        title: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(StyleConfig.edgeInsets),
                width: StyleConfig.singleLineInputWidth,
                child: TextField(
                    controller: controllerGroup.findController,
                    onChanged: (value) => _processResult(),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixText: 'Find: ',
                    )),
              ),
              Container(
                padding: EdgeInsets.all(StyleConfig.edgeInsets),
                width: StyleConfig.singleLineInputWidth,
                child: TextField(
                    controller: controllerGroup.replaceController,
                    onChanged: (value) => _processResult(),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixText: 'Replace: ',
                    )),
              ),
            ]),
        trailing: Padding(
          padding: EdgeInsets.only(right: StyleConfig.edgeInsets),
          child: RaisedButton(
            color: Colors.redAccent,
            child: Icon(Icons.clear),
            onPressed: () {
              _removePipeline(index);
              _processResult();
            },
          ),
        ),
      );
    });
  }

  Widget _resultTextField() {
    return Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        constraints: BoxConstraints(maxHeight: StyleConfig.textFieldHeight),
        child: Card(
            elevation: StyleConfig.elevation,
            child: Padding(
                padding: EdgeInsets.all(StyleConfig.edgeInsets),
                child: TextField(
                  controller: _resultStrController,
                  minLines: StyleConfig.textFieldMinLines,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Result",
                  ),
                ))));
  }

  // function

  void _addPipeline(String operation) {
    ControllerGroup controllerGroup;
    if (operation == Const.pipeline_match) {
      controllerGroup = MatchControllerGroup();
    } else if (operation == Const.pipeline_findreplace) {
      controllerGroup = FindReplaceControllerGroup();
    }
    _controllerGroupList.add(controllerGroup);
    int index = _controllerGroupList.length - 1;
    _animatedListKey.currentState
        .insertItem(index, duration: StyleConfig.animationDuration);
  }

  void _removePipeline(int index) {
    _animatedListKey.currentState.removeItem(
        index, (_, animation) => _pipelineRow(context, index, animation),
        duration: StyleConfig.animationDuration);
    _controllerGroupList.removeAt(index);
  }

  void _resetEverything() {
    _sourceStrController.clear();
    _templateStrController.clear();
    _resultStrController.clear();
    _setTextField(_splitSeparatorController, Const.default_split_separator);
    _setTextField(_joinSeparatorController, Const.default_join_separator);
    _setTextField(_placeholderController, Const.default_placeholder);
    while (_controllerGroupList.length > 0) {
      _removePipeline(0);
    }
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

  void _processResult() {
    try {
      List<String> resultStrList = _separateStr(_sourceStrController.text);
      resultStrList = _processPipeline(resultStrList);
      resultStrList = _distinctResult(resultStrList);
      resultStrList = _populateTemplate(resultStrList);
      String resultStr = _joinStr(resultStrList);
      _setTextField(_resultStrController, resultStr);
    } catch (e) {
      print(e);
    }
  }

  List<String> _separateStr(String processStr) {
    String _splitSeparator =
        _splitSeparatorController.text == Const.default_split_separator
            ? Const.split_newline_pattern
            : _splitSeparatorController.text;
    return processStr.split(RegExp(_splitSeparator));
  }

  List<String> _processPipeline(List<String> processStrList) {
    List<String> workingStrList = processStrList;
    for (ControllerGroup controllerGroup in _controllerGroupList) {
      if (controllerGroup is MatchControllerGroup) {
        workingStrList = _processMatchPipeline(controllerGroup, workingStrList);
      } else if (controllerGroup is FindReplaceControllerGroup) {
        workingStrList =
            _processFindReplacePipeline(controllerGroup, workingStrList);
      }
    }
    return workingStrList;
  }

  List<String> _processMatchPipeline(
      MatchControllerGroup controllerGroup, List<String> processStrList) {
    List<String> workingStrList = <String>[];
    for (String processStr in processStrList) {
      RegExp regExp = RegExp(controllerGroup.patternController.text,
          caseSensitive: controllerGroup.caseSensitive);
      if (regExp.hasMatch(processStr) == controllerGroup.contains) {
        workingStrList.add(processStr);
      }
    }
    return workingStrList;
  }

  List<String> _processFindReplacePipeline(
      FindReplaceControllerGroup controllerGroup, List<String> processStrList) {
    List<String> workingStrList = <String>[];
    for (String processStr in processStrList) {
      String findStr = controllerGroup.findController.text;
      String replaceStr = controllerGroup.replaceController.text;
      RegExp findRegExp = RegExp(findStr, caseSensitive: true);
      String resultStr = processStr.replaceAll(findRegExp, replaceStr);
      workingStrList.add(resultStr);
    }
    return workingStrList;
  }

  List<String> _populateTemplate(List<String> processStrList) {
    String templateStr = _templateStrController.text;
    if (templateStr.isEmpty) {
      return processStrList;
    }
    List<String> workingStrList = <String>[];
    String findStr = _placeholderController.text;
    for (String replaceStr in processStrList) {
      String resultStr = templateStr.replaceAll(findStr, replaceStr);
      workingStrList.add(resultStr);
    }
    return workingStrList;
  }

  List<String> _distinctResult(List<String> processStrList) {
    return _distinct ? processStrList.toSet().toList() : processStrList;
  }

  String _joinStr(List<String> processStrList) {
    String _joinSeparator = _joinSeparatorController.text;
    _joinSeparator = _joinSeparator.replaceAll(
        RegExp(Const.join_newline_pattern), Const.newline_character);
    _joinSeparator =
        _joinSeparator.replaceAll(Const.tab_display, Const.tab_character);
    return processStrList.join(_joinSeparator);
  }
}
