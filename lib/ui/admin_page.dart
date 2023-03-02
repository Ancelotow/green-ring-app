import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/ui/forms/add_garbage_form.dart';
import 'package:green_ring/ui/garbage_manage_page.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';

class AdminPage extends StatelessWidget {
  List<Garbage> _garbages = [];
  Widget _currentPage = GarbageManagePage();

  AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Administrateur",
        ),
      ),
      body: SafeArea(
        child: _currentPage,
      ),
      bottomNavigationBar: _getBottomNavigationBar(context),
      floatingActionButton: _getFloatingButtonAction(context),
    );
  }

  BottomNavigationBar _getBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => {

      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.delete,
          ),
          label: "Poubelles"
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.emoji_events,
            ),
            label: "Récompenses"
        ),
      ],
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
