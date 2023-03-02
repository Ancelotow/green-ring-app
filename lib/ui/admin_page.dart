import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/ui/add_garbage_form.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addGarbageForm(context),
        tooltip: 'Scanner le produit',
        child: const Icon(Icons.add),
      ),
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
                    _addGarbageNfc(context, notification.value);
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

  void _addGarbageNfc(BuildContext context, Garbage garbage) {
    showDialog(
      context: context,
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
                    Navigator.of(context).pop();
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
