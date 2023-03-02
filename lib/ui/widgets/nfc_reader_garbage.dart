import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    print('HERE: $_status');

    if (_status == NfcManagerStatus.loading) {
      _read();
      return _nfcLoading();
    } else {
      SubmitNotification(null).dispatch(context);
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
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView.builder(
                itemCount: widget.wastes.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 30,
                    child: Text(widget.wastes[index].trashColor),
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
    print("owen");
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

      print("au dessus");
      for (var element in widget.wastes) {
        var color = ColorConverter().toStringColor(garbage!.couleur);
        if (element.trashColor == color) {
          print("jonathn");
          SubmitNotification(color).dispatch(context);
          print("notif");
        }
      }
    });
    return;
  }

  void _reader() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print("OUI SCAN READ");
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);
      garbage = Garbage.fromJson(json.decode(payloadAsString));
      print(payload);
      print(payloadAsString);
      NfcManager.instance.stopSession();
    });
  }
}
