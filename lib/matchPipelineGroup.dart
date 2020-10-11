import 'package:flutter/material.dart';
import 'package:text_processor/matchPipelineRowController.dart';
import 'package:text_processor/pipelineGroup.dart';
import 'package:text_processor/pipelineRowController.dart';

class MatchPipelineGroup extends PipelineGroup {
  List<Widget> widgetList;
  List<PipelineRowController> rowControllerList;
  List<int> widgetIdList;
  int widgetIdCounter;

  MatchPipelineGroup() {
    this.widgetList = [];
    this.rowControllerList = <MatchPipelineRowController>[];
    this.widgetIdList = [];
    this.widgetIdCounter = 0;
  }
}
