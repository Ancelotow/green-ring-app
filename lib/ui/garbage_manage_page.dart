import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';
import 'package:green_ring/ui/widgets/info_error.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';
import '../models/garbage.dart';
import '../models/notifications/submit_notification.dart';

class GarbageManagePage extends StatefulWidget {
  const GarbageManagePage({Key? key}) : super(key: key);

  @override
  State<GarbageManagePage> createState() => _GarbageManagePageState();
}

class _GarbageManagePageState extends State<GarbageManagePage> {
  List<Garbage> _garbages = [];

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
            style: Theme
                .of(context)
                .textTheme
                .displayMedium,
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: ServiceAPI().getGarbages(),
            builder: (BuildContext context, AsyncSnapshot<List<Garbage>> snapshot) {
              if (snapshot.hasData) {
                _garbages = snapshot.data!;
                return _getBody(context);
              } else if (snapshot.hasError) {
                return InfoError(error: snapshot.error as Error);
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    semanticsLabel: "Chargement en cours...",
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _getBody(BuildContext context) {
    return ListView.builder(
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
    );
  }

}
