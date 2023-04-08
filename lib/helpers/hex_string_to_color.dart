import 'package:flutter/material.dart';

extension ColorConversion on String {
  Color toColor() {
    String hexColor = replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    } else {
      throw Exception('Invalid hex color');
    }
  }
}