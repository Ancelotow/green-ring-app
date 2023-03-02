import 'package:flutter/material.dart';
import 'package:green_ring/models/garbage.dart';

class IconGarbage extends StatefulWidget {
  final Garbage? garbage;

  const IconGarbage({
    Key? key,
    this.garbage,
  }) : super(key: key);

  @override
  State<IconGarbage> createState() => _IconGarbageState();
}

class _IconGarbageState extends State<IconGarbage> {
  @override
  Widget build(BuildContext context) {
    if(widget.garbage == null) {
      return const Icon(
        Icons.delete,
        color: Colors.red,
        semanticLabel: "Inconnu",
      );
    }
    return Icon(
      Icons.delete,
      color: widget.garbage!.couleur,
      semanticLabel: "",
    );
  }
}
