import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences.dart';

class ThemeController extends GetxController {
  static const String THEME_KEY = 'isDarkMode';
  final _prefs = SharedPreferences.getInstance();
  
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await _prefs;
    isDarkMode.value = prefs.getBool(THEME_KEY) ?? false;
    _updateTheme();
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await _prefs;
    await prefs.setBool(THEME_KEY, isDarkMode.value);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Helper method to check if current theme is dark
  bool get isDark => isDarkMode.value;

  // Helper method to get current theme mode
  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;
}
