import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
                          ElevatedButton(
                              child: Text('Tag Write'), onPressed: _ndefWrite),
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

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('{"site":"site","salle":"salle","couleur":"couleur"}'),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        print("OUI SCAN WRITE");
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}
