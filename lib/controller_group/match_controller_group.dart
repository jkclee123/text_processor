import 'package:flutter/material.dart';
import 'package:text_processor/controller_group/controller_group.dart';

class MatchControllerGroup extends ControllerGroup {
  bool contains;
  bool outputMatched;
  bool caseSensitive;
  TextEditingController patternController;

  MatchControllerGroup() {
    this.contains = true;
    this.outputMatched = false;
    this.caseSensitive = false;
    this.patternController = TextEditingController();
  }

  @override
  String toString() {
    return 'MatchControllerGroup(contains: $contains, outputMatched: $outputMatched, caseSensitive: $caseSensitive, patternController: ${patternController.text})';
  }
}
