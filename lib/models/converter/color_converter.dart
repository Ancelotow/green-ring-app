import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConverter {

  final Map<String, Color> _colors = {
    "blue": Colors.blue,
    "green": Colors.green,
    "grey": Colors.grey,
    "yellow": Colors.yellow,
    "black": Colors.black
  };

  Color toColor(String colorStr) {
    return _colors.entries.where((e) => e.key == colorStr).first.value;
  }

  String toStringColor(Color color) {
    return _colors.entries.where((e) => e.value == color).first.key;
  }

  Map<String, Color> getColors() => _colors;

}