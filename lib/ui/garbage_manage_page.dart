import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';
import 'package:green_ring/ui/widgets/info_error.dart';
import 'package:green_ring/ui/widgets/nfc_remove_garbage.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';
import '../models/garbage.dart';
import '../models/notifications/submit_notification.dart';
import 'forms/add_garbage_form.dart';

class GarbageManagePage extends StatefulWidget {
  const GarbageManagePage({Key? key}) : super(key: key);

  @override
  State<GarbageManagePage> createState() => _GarbageManagePageState();
}

class _GarbageManagePageState extends State<GarbageManagePage> {
  List<Garbage> _garbages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => _removeGarbageNfc(context),
              child: const Icon(
                Icons.delete_forever,
                size: 26.0,
              ),
            ),
          )
        ],
        title: const Text(
          "Admin - Poubelles",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder(
              future: ServiceAPI().getGarbages(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Garbage>> snapshot) {
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
      ),
      floatingActionButton: _getFloatingButtonAction(context),
    );
  }

  Widget _getBody(BuildContext context) {
    return ListView.builder(
      itemCount: _garbages.length,
      itemBuilder: (context, index) {
        final item = _garbages[index];
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5.0))
            ),
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
          ),
        );
      },
    );
  }

  FloatingActionButton _getFloatingButtonAction(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addGarbageForm(context),
      tooltip: 'Scanner le produit',
      child: const Icon(Icons.add),
    );
  }

  void _addGarbageForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<Garbage>>(
                  child: AddGarbageForm(),
                  onNotification: (notification) {
                    Navigator.of(context).pop();
                    ServiceAPI().addGarbage(notification.value).then((value) {
                      if (value != null) {
                        _addGarbageNfc(context, value);
                      }
                    });
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

  void _addGarbageNfc(BuildContext context, Garbage garbage) async {
    bool dialogResult = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<void>>(
                  child: NfcWriter(
                    tagValue: json.encode(garbage.toJson()),
                  ),
                  onNotification: (notification) {
                    Navigator.pop(context, true);
                    return true;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      _garbages.add(garbage);
    });
  }

  void _removeGarbageNfc(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<String>>(
                  child: const NfcRemoveGarbage(),
                  onNotification: (notification) {
                    Navigator.of(context).pop(notification.value);
                    return true;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      final resGarbage = _garbages.where((e) => e.id == result).first;
      _garbages.remove(resGarbage);
    });
  }
}
