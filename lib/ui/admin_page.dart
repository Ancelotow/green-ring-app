import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/ui/forms/add_garbage_form.dart';
import 'package:green_ring/ui/garbage_manage_page.dart';
import 'package:green_ring/ui/widgets/admin_bottom_navbar.dart';
import 'package:green_ring/ui/widgets/nfc_remove_garbage.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';

class AdminPage extends StatefulWidget {

  AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<AdminBottomNavbar> _items = [];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if(_items.isEmpty){
      _loadListBottomNavbar(context);
    }
    return Scaffold(
      appBar: AppBar(
        actions: _items[currentIndex].actions,
        title: const Text(
          "Administrateur",
        ),
      ),
      body: SafeArea(
        child: _items[currentIndex].controller,
      ),
      bottomNavigationBar: _getBottomNavigationBar(context),
      floatingActionButton: _getFloatingButtonAction(context),
    );
  }

  void _loadListBottomNavbar(BuildContext context) {
    _items.add(AdminBottomNavbar(
      itemNavbar: const BottomNavigationBarItem(
        icon: Icon(
          Icons.delete,
        ),
        label: "Poubelles",
      ),
      controller: GarbageManagePage(),
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
        ),
      ],
      callback: () => _addGarbageForm(context),
    ));
    _items.add(AdminBottomNavbar(
      itemNavbar: const BottomNavigationBarItem(
        icon: Icon(
          Icons.emoji_events,
        ),
        label: "Récompenses",
      ),
      controller: GarbageManagePage(),
      actions: [],
    ));
  }

  BottomNavigationBar _getBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => setState(() {
        currentIndex = index;
      }),
      currentIndex: currentIndex,
      items: _items.map((e) => e.itemNavbar).toList(),
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

  void _removeGarbageNfc(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<void>>(
                  child: const NfcRemoveGarbage(),
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
