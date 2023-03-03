import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/admin_page.dart';
import 'package:green_ring/ui/connect_distributor.dart';
import 'package:green_ring/ui/garbage_page.dart';
import 'package:green_ring/ui/homepage.dart';
import 'package:green_ring/ui/login_page.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final service = ServiceAPI();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.00),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 42, 255),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.00),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 227, 2, 2),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.00),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(6.00),
          hoverColor: Colors.transparent,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.bold,
              fontSize: 40.0
          ),
          displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 25.0
          )
        )
      ),
      home: LoginPage(),

      routes: {
        GarbagePage.routeName: (BuildContext context) => const GarbagePage(),
        AdminPage.routeName: (BuildContext context) => const AdminPage(),
        Homepage.routeName: (BuildContext context) => const Homepage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final dynamic arguments = settings.arguments;
        switch (settings.name) {
          case CameraPreviewPage.routeName:
            if (arguments is CameraDescription) {
              return MaterialPageRoute(
                builder: (BuildContext context) =>
                    CameraPreviewPage(camera: arguments),
              );
            }
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  ValueNotifier<dynamic> result = ValueNotifier(null);

  void _incrementCounter() {
    scanBarcodeNormal();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Text('Start barcode scan')),
              FutureBuilder<bool>(
                future: NfcManager.instance.isAvailable(),
                builder: (context, ss) => ss.data != true
                    ? Center(
                        child: Text('NfcManager.isAvailable(): ${ss.data}'))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: SingleChildScrollView(
                              child: ValueListenableBuilder<dynamic>(
                                valueListenable: result,
                                builder: (context, value, _) =>
                                    Text('${value ?? ''}'),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              child: Text('Tag Read'), onPressed: _tagRead),
                        ],
                      ),
              ),
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ]), // This trailing comma makes auto-formatting nicer for build methods.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
      print('OUIOUI');
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print("OUI SCAN READ");
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);
      print(payload);
      print(payloadAsString);
      NfcManager.instance.stopSession();
    });
  }


}
