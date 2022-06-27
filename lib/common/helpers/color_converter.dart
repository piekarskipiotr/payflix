import 'dart:ui';

class ColorConverter {
  static fromIntToColor(int value) => Color(value);
  static fromColorToInt(Color value) => int.parse('$value');
}