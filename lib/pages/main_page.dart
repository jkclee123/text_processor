import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_processor/controller_group/controller_group.dart';
import 'package:text_processor/controller_group/findreplace_controller_group.dart';
import 'package:text_processor/controller_group/match_controller_group.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:text_processor/config/style_config.dart';
import 'package:text_processor/config/const.dart' as Const;
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ThemeController _themeController;
  GlobalKey<AnimatedListState> _animatedListKey;
  Completer _completer;
  TextEditingController _sourceStr1Controller;
  TextEditingController _sourceStr2Controller;
  TextEditingController _templateStrController;
  TextEditingController _splitSeparatorController;
  TextEditingController _joinSeparatorController;
  TextEditingController _placeholderController;
  String _sourceMapping;
  bool _distinct;
  TextEditingController _resultStrController;
  List<ControllerGroup> _controllerGroupList;
  int _resultCount;

  @override
  void initState() {
    super.initState();
    _animatedListKey = GlobalKey<AnimatedListState>();
    _completer = Completer();
    _sourceStr1Controller = TextEditingController();
    _sourceStr2Controller = TextEditingController();
    _templateStrController = TextEditingController();
    _splitSeparatorController =
        TextEditingController(text: Const.default_split_separator);
    _joinSeparatorController =
        TextEditingController(text: Const.default_join_separator);
    _placeholderController =
        TextEditingController(text: Const.default_placeholder);
    _sourceMapping = Const.straight_mapping;
    _distinct = false;
    _resultStrController = TextEditingController();
    _controllerGroupList = <ControllerGroup>[];
    _resultCount = 0;
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
        _templateTextField(),
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
                        controller: _sourceStr1Controller,
                        onChanged: (value) => _processResult(),
                        minLines: StyleConfig.textFieldMinLines,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Source Text 1",
                            helperText: _getPlaceHolderStr(1),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _sourceStr1Controller.clear();
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
                        controller: _sourceStr2Controller,
                        onChanged: (value) => _processResult(),
                        minLines: StyleConfig.textFieldMinLines,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            helperText: _getPlaceHolderStr(2),
                            hintText: "Source Text 2",
                            suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _sourceStr2Controller.clear();
                                  _processResult();
                                })),
                      )))))
    ];
  }

  Widget _templateTextField() {
    return Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        constraints: BoxConstraints(maxHeight: StyleConfig.textFieldHeight),
        child: Card(
            elevation: StyleConfig.elevation,
            child: Padding(
              padding: EdgeInsets.all(StyleConfig.edgeInsets),
              child: TextField(
                controller: _templateStrController,
                onChanged: (value) => _processResult(),
                minLines: StyleConfig.templateTextFieldMinLines,
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
            )));
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
            child: Icon(Icons.refresh_outlined),
            onPressed: _resetEverything,
          )),
      if (Const.debugMode)
        Padding(
            padding: EdgeInsets.all(StyleConfig.edgeInsets),
            child: RaisedButton(
              child: Icon(Icons.directions_run),
              onPressed: _processResult,
            ))
    ];
  }

  List<Widget> _settingsInputList() {
    return [
      Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        width: StyleConfig.shortInputWidth,
        child: TextField(
            controller: _splitSeparatorController,
            onChanged: (value) => _processResult(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                borderSide: BorderSide(
                    color: _themeController.theme.data.accentColor,
                    width: StyleConfig.borderWidth),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                borderSide: BorderSide(
                    color: _themeController.theme.data.disabledColor,
                    width: StyleConfig.borderWidth),
              ),
              labelText: 'Split',
            )),
      ),
      Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        width: StyleConfig.shortInputWidth,
        child: TextField(
            controller: _joinSeparatorController,
            onChanged: (value) => _processResult(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                borderSide: BorderSide(
                    color: _themeController.theme.data.accentColor,
                    width: StyleConfig.borderWidth),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                borderSide: BorderSide(
                    color: _themeController.theme.data.disabledColor,
                    width: StyleConfig.borderWidth),
              ),
              labelText: 'Join',
            )),
      ),
      Container(
        padding: EdgeInsets.all(StyleConfig.edgeInsets),
        width: StyleConfig.longInputWidth,
        child: TextField(
            controller: _placeholderController,
            onChanged: (value) => _processResult(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                  borderSide: BorderSide(
                      color: _themeController.theme.data.accentColor,
                      width: StyleConfig.borderWidth),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                  borderSide: BorderSide(
                      color: _themeController.theme.data.disabledColor,
                      width: StyleConfig.borderWidth),
                ),
                labelText: 'Placeholder')),
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
      Container(
          padding: EdgeInsets.all(StyleConfig.edgeInsets),
          width: StyleConfig.dropdownWidth,
          child: DropdownButtonFormField(
            value: _sourceMapping,
            items: Const.sourceMappingList,
            onChanged: (value) {
              _sourceMapping = value;
              _processResult();
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                  borderSide: BorderSide(
                      color: _themeController.theme.data.accentColor,
                      width: StyleConfig.borderWidth),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(StyleConfig.borderRadius),
                  borderSide: BorderSide(
                      color: _themeController.theme.data.disabledColor,
                      width: StyleConfig.borderWidth),
                ),
                labelText: 'Mapping'),
          )),
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
      return Column(children: [
        ListTile(
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
                          if (!value) {
                            setState(
                                () => controllerGroup.outputMatched = false);
                          }
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
                    Text('Output Matched'),
                    Switch(
                        value: controllerGroup.outputMatched,
                        onChanged: (value) {
                          if (value) {
                            setState(() => controllerGroup.contains = true);
                          }
                          setState(() => controllerGroup.outputMatched = value);
                          _processResult();
                        })
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(StyleConfig.edgeInsets),
                child: Column(
                  children: [
                    Text('Case Sensitive'),
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
                width: StyleConfig.longInputWidth,
                child: TextField(
                    controller: controllerGroup.patternController,
                    onChanged: (value) => _processResult(),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(StyleConfig.borderRadius),
                        borderSide: BorderSide(
                            color: _themeController.theme.data.accentColor,
                            width: StyleConfig.borderWidth),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(StyleConfig.borderRadius),
                        borderSide: BorderSide(
                            color: _themeController.theme.data.disabledColor,
                            width: StyleConfig.borderWidth),
                      ),
                      labelText: 'Match',
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
        ),
        Divider()
      ]);
    });
  }

  Widget _getFindReplacePipelineTile(
      FindReplaceControllerGroup controllerGroup, int index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(children: [
        ListTile(
          title: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(StyleConfig.edgeInsets),
                  child: Column(
                    children: [
                      Text('Case Sensitive'),
                      Switch(
                          value: controllerGroup.caseSensitive,
                          onChanged: (value) {
                            setState(
                                () => controllerGroup.caseSensitive = value);
                            _processResult();
                          })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(StyleConfig.edgeInsets),
                  width: StyleConfig.longInputWidth,
                  child: TextField(
                      controller: controllerGroup.findController,
                      onChanged: (value) => _processResult(),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(StyleConfig.borderRadius),
                          borderSide: BorderSide(
                              color: _themeController.theme.data.accentColor,
                              width: StyleConfig.borderWidth),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(StyleConfig.borderRadius),
                          borderSide: BorderSide(
                              color: _themeController.theme.data.disabledColor,
                              width: StyleConfig.borderWidth),
                        ),
                        labelText: 'Find',
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(StyleConfig.edgeInsets),
                  width: StyleConfig.longInputWidth,
                  child: TextField(
                      controller: controllerGroup.replaceController,
                      onChanged: (value) => _processResult(),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(StyleConfig.borderRadius),
                          borderSide: BorderSide(
                              color: _themeController.theme.data.accentColor,
                              width: StyleConfig.borderWidth),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(StyleConfig.borderRadius),
                          borderSide: BorderSide(
                              color: _themeController.theme.data.disabledColor,
                              width: StyleConfig.borderWidth),
                        ),
                        labelText: 'Replace',
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
        ),
        Divider()
      ]);
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
                    helperText: "$_resultCount",
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

  String _getPlaceHolderStr(int index) {
    return _placeholderController.text + index.toString();
  }

  void _resetEverything() {
    while (_controllerGroupList.length > 0) {
      _removePipeline(0);
    }
    _sourceStr1Controller.clear();
    _sourceStr2Controller.clear();
    _templateStrController.clear();
    _resultStrController.clear();
    _setTextField(_splitSeparatorController, Const.default_split_separator);
    _setTextField(_joinSeparatorController, Const.default_join_separator);
    _setTextField(_placeholderController, Const.default_placeholder);
    setState(() => _distinct = false);
    _setResultCount(0);
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

  void _setResultCount(int resultCount) {
    setState(() => _resultCount = resultCount);
  }

  void _processResult() {
    try {
      List<String> sourceStr1List = _separateStr(_sourceStr1Controller.text);
      sourceStr1List = _processPipeline(sourceStr1List);
      sourceStr1List = _distinctResult(sourceStr1List);
      List<String> sourceStr2List = _separateStr(_sourceStr2Controller.text);
      sourceStr2List = _processPipeline(sourceStr2List);
      sourceStr2List = _distinctResult(sourceStr2List);
      List<Tuple2<String, String>> sourceTupleList =
          _zipSourceList(sourceStr1List, sourceStr2List);
      List<String> resultStrList = _populateTemplate(sourceTupleList);
      String resultStr = _joinStr(resultStrList);
      _setTextField(_resultStrController, resultStr);
      _setResultCount(resultStrList.length == 1 && resultStrList[0].length == 0
          ? 0
          : resultStrList.length);
    } catch (e, stacktrace) {
      if (Const.debugMode) {
        _completer.completeError(e, stacktrace);
      } else {
        print(e);
      }
    }
  }

  List<String> _separateStr(String sourceStr) {
    String _splitSeparator =
        _splitSeparatorController.text == Const.default_split_separator
            ? Const.split_newline_pattern
            : _splitSeparatorController.text;
    return sourceStr.split(RegExp(_splitSeparator));
  }

  List<String> _processPipeline(List<String> sourceStrList) {
    List<String> resultStrList = sourceStrList;
    for (ControllerGroup controllerGroup in _controllerGroupList) {
      if (controllerGroup is MatchControllerGroup) {
        resultStrList = _processMatchPipeline(controllerGroup, resultStrList);
      } else if (controllerGroup is FindReplaceControllerGroup) {
        resultStrList =
            _processFindReplacePipeline(controllerGroup, resultStrList);
      }
    }
    return resultStrList;
  }

  List<String> _processMatchPipeline(
      MatchControllerGroup controllerGroup, List<String> sourceStrList) {
    List<String> resultStrList = [];
    RegExp regExp = RegExp(controllerGroup.patternController.text,
        caseSensitive: controllerGroup.caseSensitive);
    for (String sourceStr in sourceStrList) {
      if (regExp.hasMatch(sourceStr) == controllerGroup.contains) {
        if (controllerGroup.outputMatched) {
          RegExpMatch regExpMatch = regExp.firstMatch(sourceStr);
          if (regExpMatch.groupCount > 0) {
            resultStrList.add(regExpMatch.group(1));
          } else {
            resultStrList.add(regExpMatch.group(0));
          }
        } else {
          resultStrList.add(sourceStr);
        }
      }
    }
    return resultStrList;
  }

  List<String> _processFindReplacePipeline(
      FindReplaceControllerGroup controllerGroup, List<String> sourceStrList) {
    List<String> resultStrList = [];
    String findStr = controllerGroup.findController.text;
    String replaceStr = controllerGroup.replaceController.text;
    RegExp findRegExp =
        RegExp(findStr, caseSensitive: controllerGroup.caseSensitive);
    for (String sourceStr in sourceStrList) {
      String resultStr = sourceStr.replaceAll(findRegExp, replaceStr);
      resultStrList.add(resultStr);
    }
    return resultStrList;
  }

  List<String> _distinctResult(List<String> sourceStrList) {
    return _distinct ? sourceStrList.toSet().toList() : sourceStrList;
  }

  List<Tuple2<String, String>> _zipSourceList(
      List<String> sourceStr1List, List<String> sourceStr2List) {
    List<Tuple2<String, String>> resultTupleList;
    if (_sourceMapping == Const.straight_mapping) {
      resultTupleList = _straightZipSourceList(sourceStr1List, sourceStr2List);
    } else if (_sourceMapping == Const.cross_mapping) {
      resultTupleList = _crossZipSourceList(sourceStr1List, sourceStr2List);
    }
    return resultTupleList;
  }

  List<Tuple2<String, String>> _straightZipSourceList(
      List<String> sourceStr1List, List<String> sourceStr2List) {
    while (sourceStr2List.length < sourceStr1List.length) {
      sourceStr2List.add('');
    }
    List<Tuple2<String, String>> resultTupleList = [];
    sourceStr1List.asMap().forEach((index, sourceStr1) =>
        resultTupleList.add(Tuple2(sourceStr1, sourceStr2List[index])));
    return resultTupleList;
  }

  List<Tuple2<String, String>> _crossZipSourceList(
      List<String> sourceStr1List, List<String> sourceStr2List) {
    List<Tuple2<String, String>> resultTupleList = [];
    for (String sourceStr1 in sourceStr1List) {
      for (String sourceStr2 in sourceStr2List) {
        resultTupleList.add(Tuple2(sourceStr1, sourceStr2));
      }
    }
    return resultTupleList;
  }

  List<String> _populateTemplate(List<Tuple2<String, String>> sourceTupleList) {
    String placeholder1Str = _getPlaceHolderStr(1);
    String placeholder2Str = _getPlaceHolderStr(2);
    String templateStr = _templateStrController.text.isNotEmpty
        ? _templateStrController.text
        : _sourceStr2Controller.text.isEmpty
            ? '$placeholder1Str'
            : '$placeholder1Str: $placeholder2Str';
    List<String> resultStrList = [];
    for (Tuple2<String, String> sourceTuple in sourceTupleList) {
      String resultStr =
          templateStr.replaceAll(placeholder1Str, sourceTuple.item1);
      resultStr = resultStr.replaceAll(placeholder2Str, sourceTuple.item2);
      resultStrList.add(resultStr);
    }
    return resultStrList;
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
