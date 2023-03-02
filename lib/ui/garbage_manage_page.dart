import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';

import '../models/garbage.dart';
import '../models/notifications/submit_notification.dart';

class GarbageManagePage extends StatefulWidget {
  GarbageManagePage({Key? key}) : super(key: key);

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
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(item.id.toString()),
                background: _backgroundListDismissible(context),
                onDismissed: (direction) => _removeGarbage(context, index),
                child: Padding(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _backgroundListDismissible(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Supprimer",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _removeGarbage(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<void>>(
                  child: NfcWriter(
                    tagValue: json.encode(""),
                  ),
                  onNotification: (notification) {
                    Navigator.of(context).pop();
                    _garbages.removeAt(index);
                    return true;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
