import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StyleConfig {
  static double elevation = 5.0;
  static int textFieldMinLines = 6;
  static int templateTextFieldMinLines = 4;
  static double shortInputWidth = 130;
  static double longInputWidth = 170;
  static double dropdownWidth = 200;
  static double textFieldFlexThreshold = 800;
  static double borderWidth = 1.5;
  static double borderRadius = 5.0;

  static double _edgeInsetsMultiplier = 0.01;
  static double _textFieldHeightHoriMultiplier = 0.5;
  static double _textFieldHeightVertMultiplier = 0.25;
  static double _pipelinewidthMultiplier = 0.6;

  static double _screenWidth;
  static double _screenHeight;

  static Axis flexDirection;

  static Duration animationDuration = Duration(milliseconds: 300);

  static double edgeInsets;
  static double textFieldHeight;
  static double spacing;
  static double pipelinewidth;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    flexDirection =
        _screenWidth > textFieldFlexThreshold ? Axis.horizontal : Axis.vertical;
    edgeInsets = _screenHeight * _edgeInsetsMultiplier;
    textFieldHeight = flexDirection == Axis.horizontal
        ? _screenHeight * _textFieldHeightHoriMultiplier
        : _screenHeight * _textFieldHeightVertMultiplier;
    pipelinewidth = _screenWidth * _pipelinewidthMultiplier;
  }
}
