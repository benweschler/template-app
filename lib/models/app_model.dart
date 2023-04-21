import 'package:flutter/material.dart' show ThemeMode;
import 'package:template_app/styles/theme.dart';
import 'package:template_app/utils/easy_notifier.dart';

class AppModel extends EasyNotifier {
  final EasyNotifier routerRefreshNotifier = EasyNotifier();

  /// Whether the app has been initialized with user data.
  bool _isInitialized = false;

  /// The active theme for the app.
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  set themeMode(themeMode) => notify(() => _themeMode = themeMode);

  ThemeType get lightThemeType {
    if (themeMode == ThemeMode.dark) return ThemeType.dark;
    return ThemeType.light;
  }

  ThemeType get darkThemeType {
    if (themeMode == ThemeMode.light) return ThemeType.light;
    return ThemeType.dark;
  }

  bool get isInitialized => _isInitialized;

  set isInitialized(bool value) {
    _isInitialized = value;
    routerRefreshNotifier.notifyListeners();
  }
}
