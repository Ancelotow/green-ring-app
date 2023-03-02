import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';

import '../models/garbage.dart';
import '../models/notifications/submit_notification.dart';

class GarbageManagePage extends StatefulWidget {
  const GarbageManagePage({Key? key}) : super(key: key);

  @override
  State<GarbageManagePage> createState() => _GarbageManagePageState();
}

class _GarbageManagePageState extends State<GarbageManagePage> {
  List<Garbage> _garbages = [
    Garbage(id: 1, site: "ESGI", salle: "A07", couleur: Colors.blue),
    Garbage(id: 2, site: "ESGI", salle: "A07", couleur: Colors.yellow),
    Garbage(id: 3, site: "ESGI", salle: "A07", couleur: Colors.blue),
    Garbage(id: 4, site: "ESGI", salle: "A07", couleur: Colors.grey),
    Garbage(id: 5, site: "ESGI", salle: "Administration", couleur: Colors.blue),
    Garbage(
        id: 6, site: "ESGI", salle: "Administration", couleur: Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Poubelles",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _garbages.length,
            itemBuilder: (context, index) {
              final item = _garbages[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconGarbage(garbage: item),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Site: ${item.site}"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Salle: ${item.salle}")
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}
