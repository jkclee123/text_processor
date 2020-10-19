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

  TextEditingController _sourceStrController;
  TextEditingController _templateStrController;
  TextEditingController _splitSeparatorController;
  TextEditingController _joinSeparatorController;
  TextEditingController _placeholderController;
  TextEditingController _resultStrController;
  List<ControllerGroup> _controllerGroupList;
  GlobalKey<AnimatedListState> _animatedListKey;

  @override
  void initState() {
    super.initState();
    _sourceStrController = TextEditingController();
    _templateStrController = TextEditingController();
    _splitSeparatorController =
        TextEditingController(text: Const.default_split_separator);
    _joinSeparatorController =
        TextEditingController(text: Const.default_join_separator);
    _placeholderController =
        TextEditingController(text: Const.default_placeholder);
    _resultStrController = TextEditingController();
    _controllerGroupList = <ControllerGroup>[];
    _animatedListKey = GlobalKey<AnimatedListState>();
  }

  @override
  Widget build(BuildContext context) {
    _themeController = ThemeProvider.controllerOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style:
              TextStyle(color: _themeController.theme.data.bottomAppBarColor),
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
            color: Colors.orange,
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

    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child: tile);
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
                    hintText: 'Match',
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
                      hintText: 'Find',
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
                      hintText: 'Replace',
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
      List<String> separatedStrList = _separateStr(_sourceStrController.text);
      List<String> pipelinedStrList = _processPipeline(separatedStrList);
      List<String> templatedStrList = _populateTemplate(pipelinedStrList);
      String joinedStr = _joinStr(templatedStrList);
      String resultStr = _decodeEscape(joinedStr);
      _setTextField(_resultStrController, resultStr);
    } catch (e) {
      print(e);
    }
  }

  List<String> _separateStr(String sourceStr) {
    String _splitSeparator =
        _splitSeparatorController.text == Const.default_split_separator
            ? Const.newline_pattern
            : _splitSeparatorController.text;
    return sourceStr.split(RegExp(_splitSeparator));
  }

  List<String> _processPipeline(List<String> separatedStrList) {
    List<String> processStrList = separatedStrList;
    for (ControllerGroup controllerGroup in _controllerGroupList) {
      if (controllerGroup is MatchControllerGroup) {
        processStrList = _processMatchPipeline(controllerGroup, processStrList);
      } else if (controllerGroup is FindReplaceControllerGroup) {
        processStrList =
            _processFindReplacePipeline(controllerGroup, processStrList);
      }
    }
    return processStrList;
  }

  List<String> _processMatchPipeline(
      MatchControllerGroup controllerGroup, List<String> processStrList) {
    List<String> pipelinedStrList = <String>[];
    for (String processStr in processStrList) {
      RegExp regExp = RegExp(controllerGroup.patternController.text,
          caseSensitive: controllerGroup.caseSensitive);
      if (regExp.hasMatch(processStr) == controllerGroup.contains) {
        pipelinedStrList.add(processStr);
      }
    }
    return pipelinedStrList;
  }

  List<String> _processFindReplacePipeline(
      FindReplaceControllerGroup controllerGroup, List<String> processStrList) {
    List<String> pipelinedStrList = <String>[];
    for (String processStr in processStrList) {
      String findStr = controllerGroup.findController.text;
      String replaceStr = controllerGroup.replaceController.text;
      RegExp findRegExp = RegExp(findStr, caseSensitive: true);
      String resultStr = processStr.replaceAll(findRegExp, replaceStr);
      pipelinedStrList.add(resultStr);
    }
    return pipelinedStrList;
  }

  List<String> _populateTemplate(List<String> pipelinedStrList) {
    String templateStr = _templateStrController.text;
    if (templateStr.isEmpty) {
      return pipelinedStrList;
    }
    List<String> templatedStrList = <String>[];
    String findStr = _placeholderController.text;
    for (String replaceStr in pipelinedStrList) {
      String resultStr = templateStr.replaceAll(findStr, replaceStr);
      templatedStrList.add(resultStr);
    }
    return templatedStrList;
  }

  String _joinStr(List<String> templatedStrList) {
    String _joinSeparator = _joinSeparatorController.text;
    return templatedStrList.join(_joinSeparator);
  }

  String _decodeEscape(String joinedStr) {
    String resultStr = joinedStr;
    resultStr =
        joinedStr.replaceAll(Const.newline_display, Const.newline_character);
    resultStr = resultStr.replaceAll(Const.tab_display, Const.tab_character);
    return resultStr;
  }
}
