import 'dart:ui';

class ColorConverter {
  static Color fromIntToColor(int value) => Color(value);
  static int fromColorToInt(Color value) => value.value;
}