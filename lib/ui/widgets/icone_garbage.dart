import 'package:flutter/material.dart';
import 'package:green_ring/models/garbage.dart';

class IconGarbage extends StatelessWidget {
  final Garbage? garbage;

  const IconGarbage({
    Key? key,
    this.garbage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(garbage == null) {
      return const Icon(
        Icons.delete,
        color: Colors.red,
        semanticLabel: "Inconnu",
      );
    }
    return const Icon(
      Icons.delete,
      color: Colors.red,
      semanticLabel: "",
    );
  }
}
