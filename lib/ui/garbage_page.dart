import 'package:flutter/material.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';
import '../models/garbage.dart';

class GarbagePage extends StatefulWidget {
  static String routeName = "GarbagePage";
  const GarbagePage({Key? key}) : super(key: key);

  @override
  State<GarbagePage> createState() => _GarbagePageState();
}

class _GarbagePageState extends State<GarbagePage> {
  Garbage? _selectedGarbage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IconGarbage(garbage: _selectedGarbage)
      ),
    );
  }
}
