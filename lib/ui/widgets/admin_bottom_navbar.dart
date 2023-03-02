import 'package:flutter/cupertino.dart';

class AdminBottomNavbar {
  BottomNavigationBarItem itemNavbar;
  Widget controller;
  List<Widget> actions;
  Function? callback;

  AdminBottomNavbar({
    required this.itemNavbar,
    required this.controller,
    required this.actions,
    this.callback,
  });
}
