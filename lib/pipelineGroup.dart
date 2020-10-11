import 'package:flutter/material.dart';
import 'package:text_processor/pipelineRowController.dart';

abstract class PipelineGroup {
  List<Widget> widgetList;
  List<PipelineRowController> rowControllerList;
  List<int> widgetIdList;
  int widgetIdCounter;
}
