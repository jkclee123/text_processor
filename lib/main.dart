import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:text_processor/config/const.dart' as Const;
import 'package:text_processor/pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) =>
          _themeProviderInitCallBack(controller, previouslySavedThemeFuture),
      themes: Const.appThemeList,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            title: Const.appTitle,
            home: MainPage(title: Const.appTitle),
          ),
        ),
      ),
    );
  }

  void _themeProviderInitCallBack(ThemeController controller,
      Future<String> previouslySavedThemeFuture) async {
    String savedTheme = await previouslySavedThemeFuture;
    if (savedTheme != null) {
      controller.setTheme(savedTheme);
    } else {
      Brightness platformBrightness =
          SchedulerBinding.instance.window.platformBrightness;
      if (platformBrightness == Brightness.dark) {
        controller.setTheme(Const.darkThemeId);
      } else {
        controller.setTheme(Const.lightThemeId);
      }
      controller.forgetSavedTheme();
    }
  }
}
