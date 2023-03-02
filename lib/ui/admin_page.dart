import 'package:flutter/material.dart';
import 'package:green_ring/models/item_bottom_navbar.dart';
import 'package:green_ring/ui/garbage_manage_page.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<ItemBottomNavbar> _items = [
    ItemBottomNavbar(
      itemNavbar: const BottomNavigationBarItem(
        icon: Icon(
          Icons.delete,
        ),
        label: "Poublles",
      ),
      controller: const GarbageManagePage(),
    ),
    ItemBottomNavbar(
      itemNavbar: const BottomNavigationBarItem(
        icon: Icon(
          Icons.emoji_events_rounded,
        ),
        label: "Récompenses",
      ),
      controller: const GarbageManagePage(),
    )
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _items[currentIndex].controller,
      ),
      bottomNavigationBar: _getBottomNavigationBar(context),
    );
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
}
