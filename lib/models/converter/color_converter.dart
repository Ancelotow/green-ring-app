import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConverter {

  final Map<String, Color> _colors = {
    "bleu": Colors.blue,
    "vert": Colors.green,
    "gris": Colors.grey,
    "jaune": Colors.yellow
  };

  Color toColor(String colorStr) {
    return _colors.entries.where((e) => e.key == colorStr).first.value;
  }

  String toStringColor(Color color) {
    return _colors.entries.where((e) => e.value == color).first.key;
  }

}