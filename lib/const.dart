import 'package:flutter/material.dart';

const String DEFAULT_DELIMITOR = '\n';
const String DEFAULT_PLACEHOLDER = '##';

const double PADDING_EDGEINSETS = 0.003;
const double CARD_EDGEINSETS = 0.01;
const double TEXTFIELD_WIDTH = 1 - PADDING_EDGEINSETS * 2;
const double TEXTFIELD_HEIGHT = 0.25;
const double SQUARE_BTN_LENGTH = 40;

const String DROPDOWN_SPLIT = 'split';
const String DROPDOWN_JOIN = 'join';

const String PIPELINE_OP_MATCH = 'match';
const String PIPELINE_OP_FINDREPLACE = 'findeplace';

const List<DropdownMenuItem<String>> DELIMITOR_LIST = [
  DropdownMenuItem(
    value: "\n",
    child: Text(
      "Newline",
    ),
  ),
  DropdownMenuItem(
    value: ", ",
    child: Text(
      "Comma Space",
    ),
  ),
  DropdownMenuItem(
    value: ",",
    child: Text(
      "Comma",
    ),
  ),
];
