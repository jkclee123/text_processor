import 'package:flutter/material.dart';
import 'package:text_processor/pipelineRowController.dart';

class MatchPipelineRowController extends PipelineRowController {
  bool contains;
  bool matchedText;
  TextEditingController patternController;

  MatchPipelineRowController() {
    this.contains = true;
    this.matchedText = false;
    this.patternController = TextEditingController();
  }

  @override
  String toString() {
    return "MatchPipelineRowController(contains: $contains, matchedText: $matchedText, patternController: $patternController)";
  }
}
