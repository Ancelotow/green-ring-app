import 'package:flutter/material.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';

class GarbageCard extends StatelessWidget {
  const GarbageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


/// ElevatedCard
class ElevatedCard extends StatelessWidget {
  final Garbage? garbage;
  const ElevatedCard({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
            width: 80,
            height: 120,
            child: Center(child: IconGarbage(garbage: garbage)),
        ),
      ),
    );
  }
}

/// FilledCard
class FilledCard extends StatelessWidget {
  final Garbage? garbage;
  const FilledCard({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primary,
        child: SizedBox(
          width: 80,
          height: 120,
          child: Center(child: IconGarbage(garbage: garbage)),
        ),
      ),
    );
  }
}

/// OutlinedCard
class OutlinedCard extends StatelessWidget {
  final Garbage? garbage;
  const OutlinedCard({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          width: 80,
          height: 120,
          child: Center(child: IconGarbage(garbage: garbage)),
        ),
      ),
    );
  }
}