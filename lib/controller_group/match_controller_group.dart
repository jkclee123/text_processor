import 'package:flutter/material.dart';
import 'package:text_processor/controller_group/controller_group.dart';

class MatchControllerGroup extends ControllerGroup {
  bool contains;
  bool caseSensitive;
  TextEditingController patternController;

  MatchControllerGroup() {
    this.contains = true;
    this.caseSensitive = false;
    this.patternController = TextEditingController();
  }

  @override
  String toString() {
    return 'MatchControllerGroup(contains: $contains, caseSensitive: $caseSensitive, patternController: ${patternController.text})';
  }
}
