library constants;

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

const String appTitle = 'Text Processor';

const String lightThemeId = 'light';
const String darkThemeId = 'dark';

const String default_split_separator = newline_display;
const String default_join_separator = newline_display;
const String default_placeholder = '##';

const String newline_display = '\\n';
const String tab_display = '\\t';
const String newline_character = '\n';
const String tab_character = '\t';

const String newline_pattern = '(\r\n|\r|\n)';

const String pipeline_match = 'Match';
const String pipeline_findreplace = 'Find Replace';

final List<AppTheme> appThemeList = <AppTheme>[
  AppTheme(
      id: lightThemeId,
      data: ThemeData.light().copyWith(
        primaryColor: Colors.indigo[600],
      ),
      description: ''),
  AppTheme(
      id: darkThemeId,
      data: ThemeData.dark().copyWith(
        primaryColor: Colors.amberAccent[400],
      ),
      description: '')
];
