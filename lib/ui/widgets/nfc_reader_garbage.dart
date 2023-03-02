import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:green_ring/models/converter/color_converter.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/models/nfc_manager_status.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/models/waste.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcReaderGarbage extends StatefulWidget {
  final List<Waste> wastes;

  const NfcReaderGarbage({Key? key, required this.wastes}) : super(key: key);

  @override
  State<NfcReaderGarbage> createState() => _NfcReaderGarbageState();
}

class _NfcReaderGarbageState extends State<NfcReaderGarbage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  final NfcManagerStatus _status = NfcManagerStatus.loading;
  Garbage? garbage;
  List<String> groupedWastes = [];

  @override
  Widget build(BuildContext context) {

    groupedWastes = groupBy(widget.wastes, (p0) => p0.trashColor).keys.toList();


    if (_status == NfcManagerStatus.loading) {
      _read();
      return _nfcLoading();
    } else {
      return _nfcLoading();
    }
  }

  Widget _nfcLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: 75,
            child: ListView.builder(
                itemCount: groupedWastes.length,
                itemBuilder: (context, index) {
                  Color color = ColorConverter().toColor(groupedWastes[index]);

                  return SizedBox(
                    height: 30,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Scannez la poubelle '),
                        Icon(Icons.delete, color: color),
                        const Text(' !'),
                      ],
                    ),
                  );
                }),
          ),
        ),
        const SizedBox(height: 40),
        const Icon(
          Icons.nfc,
          size: 20,
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        const Text("En attente du tag NFC"),
      ],
    );
  }

  Future<void> _read() async {
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);
      payloadAsString = payloadAsString.substring(3, payloadAsString.length);
      garbage = Garbage.fromJson(json.decode(payloadAsString));

      for (var element in widget.wastes) {
        var color = ColorConverter().toStringColor(garbage!.couleur);
        if (element.trashColor == color) {
          setState(() {
            groupedWastes.removeWhere((element) {
              return element == color;
            });
          });
          SubmitNotification(color).dispatch(context);
        }
      }
    });
    return;
  }

}
