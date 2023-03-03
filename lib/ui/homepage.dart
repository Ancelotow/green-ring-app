import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:green_ring/models/user.dart';
import 'package:green_ring/models/waste.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/garbage_page.dart';

class Homepage extends StatefulWidget {
  static String routeName = "HomePage";

  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late ConfettiController _controllerCenter;
  ServiceAPI service = ServiceAPI();
  User? user;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 20));
    _fillUser();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _fillUser();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Boujour ${user?.firstname} ${user?.lastname} !",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text("${user?.coins}\npoints 🎉",
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirection: pi / 2,
                  maxBlastForce: 10,
                  minBlastForce: 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 5,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _scanBarcode(context),
          tooltip: 'Scanner le produit',
          child: const Icon(Icons.qr_code),
        ),
      ),
    );
  }

  void _fillUser() async {
    user = await service.getUser('1311d693-b49c-4b89-ab77-9c188cb10538');
  }

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print("HERE");
      print(result);
      await _printLoader(result);
    } on PlatformException {
      print("Erreur: Failed to get platform version.");
    }
  }

  Future<void> _printLoader(result) async {
    AlertDialog alert = AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(
          backgroundColor: Colors.blue,
        ),
        Container(margin: const EdgeInsets.only(left: 7), child: const Text("Loading...")),
      ]),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    List<Waste> wastes = await service.getWastesByBarcode(result);
    print("FINALLY");
    print (wastes.first.trashColor);
    print (wastes);
    Navigator.pop(context, true);
    Navigator.of(context).push(route);
  }
}
