import 'dart:math';
import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:green_ring/ui/camera_preview_page.dart';
import 'package:green_ring/models/user.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/garbage_page.dart';
import '../models/session.dart';

class Homepage extends StatefulWidget {
  static String routeName = "HomePage";

  const Homepage({Key? key}) : super(key: key);

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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _takePhoto(context),
              tooltip: 'Scanner le produit',
              backgroundColor: Colors.green,
              child: const Icon(Icons.remove_red_eye),
            ),
            SizedBox(
              height: 25,
            ),
            FloatingActionButton(
              onPressed: () => _scanBarcode(context),
              tooltip: 'Scanner le code-barre',
              child: const Icon(Icons.qr_code),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.pushNamed(
      context,
      CameraPreviewPage.routeName,
      arguments: firstCamera
    );
  }

  void _fillUser() async {
    user = Session.instance()!.user;
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
