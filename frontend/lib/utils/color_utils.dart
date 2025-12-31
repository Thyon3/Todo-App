import 'package:flutter/material.dart';

class ColorUtils {
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  static Color hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  static bool isColorLight(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  static Color getContrastColor(Color color) {
    return isColorLight(color) ? Colors.black : Colors.white;
  }
}
