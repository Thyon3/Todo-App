import 'package:vibration/vibration.dart';

class HapticUtils {
  static Future<void> lightImpact() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 30);
    }
  }

  static Future<void> mediumImpact() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 50);
    }
  }

  static Future<void> heavyImpact() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 70);
    }
  }

  static Future<void> selectionClick() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 10);
    }
  }

  static Future<void> success() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 50);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 50);
    }
  }

  static Future<void> error() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 100);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 100);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 100);
    }
  }
}
