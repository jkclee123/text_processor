import 'package:flutter/material.dart';
import 'package:text_processor/pipelineRowController.dart';

class PipelineGroup {
  List<Widget> widgetList;
  List<PipelineRowController> rowControllerList;
  List<int> widgetIdList;
  int widgetIdCounter;

  PipelineGroup() {
    this.widgetList = [];
    this.rowControllerList = [];
    this.widgetIdList = [];
    this.widgetIdCounter = 0;
  }
}
