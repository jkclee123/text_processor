import 'package:flutter/material.dart';
import 'package:text_processor/controller_group/controller_group.dart';

class FindReplaceControllerGroup extends ControllerGroup {
  bool caseSensitive;
  TextEditingController findController;
  TextEditingController replaceController;

  FindReplaceControllerGroup() {
    this.caseSensitive = false;
    this.findController = TextEditingController();
    this.replaceController = TextEditingController();
  }

  @override
  String toString() {
    return 'FindReplaceControllerGroup(caseSensitive: $caseSensitive, findController: ${findController.text}, ' +
        'replaceController: ${replaceController.text})';
  }
}
