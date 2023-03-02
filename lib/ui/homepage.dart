import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:green_ring/ui/garbage_page.dart';

class Homepage extends StatefulWidget {
  static String routeName = "HomePage";

  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 20));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Boujour Charles DUPOND !",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "13\npoints",
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
    );
  }

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      Navigator.of(context).pushNamed(GarbagePage.routeName);
      // TODO: Appeler l'API pour envoyer le code barre
    } on PlatformException {
      print("Erreur: Failed to get platform version.");
    }
  }
}
