import 'package:flutter/material.dart';
import 'package:text_processor/pipelineRowController.dart';

class MatchPipelineRowController extends PipelineRowController {
  bool contains;
  bool matchedText;
  bool caseSensitive;
  TextEditingController matchGroupController;
  TextEditingController patternController;

  MatchPipelineRowController() {
    this.contains = true;
    this.matchedText = false;
    this.caseSensitive = false;
    this.matchGroupController = TextEditingController(text: "0");
    this.patternController = TextEditingController();
  }

  @override
  String toString() {
    return "MatchPipelineRowController(contains: $contains, matchedText: $matchedText, patternController: $patternController)";
  }
}
