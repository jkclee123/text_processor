import 'package:flutter/material.dart';
import 'package:text_processor/controller_group/controller_group.dart';

class FindReplaceControllerGroup extends ControllerGroup {
  TextEditingController findController;
  TextEditingController replaceController;

  FindReplaceControllerGroup() {
    findController = TextEditingController();
    replaceController = TextEditingController();
  }

  @override
  String toString() {
    return 'FindReplaceControllerGroup(findController: ${findController.text}, ' +
        'replaceController: ${replaceController.text})';
  }
}
