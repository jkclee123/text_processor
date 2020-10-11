import 'package:flutter/material.dart';
import 'package:text_processor/findReplacePipelineRowController.dart';
import 'package:text_processor/pipelineGroup.dart';
import 'package:text_processor/pipelineRowController.dart';

class FindReplacePipelineGroup extends PipelineGroup {
  List<Widget> widgetList;
  List<PipelineRowController> rowControllerList;
  List<int> widgetIdList;
  int widgetIdCounter;

  FindReplacePipelineGroup() {
    this.widgetList = [];
    this.rowControllerList = <FindReplacePipelineRowController>[];
    this.widgetIdList = [];
    this.widgetIdCounter = 0;
  }
}
