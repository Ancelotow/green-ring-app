import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:green_ring/models/nfc_manager_status.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../models/garbage.dart';
import '../../models/notifications/submit_notification.dart';

class NfcRemoveGarbage extends StatefulWidget {
  const NfcRemoveGarbage({Key? key}) : super(key: key);

  @override
  State<NfcRemoveGarbage> createState() => _NfcRemoveGarbageState();
}

class _NfcRemoveGarbageState extends State<NfcRemoveGarbage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  NfcManagerStatus _status = NfcManagerStatus.loading;

  @override
  Widget build(BuildContext context) {
    if (_status == NfcManagerStatus.loading) {
      _writer();
      return _nfcLoading();
    } else {
      SubmitNotification(null).dispatch(context);
      return _nfcSuccess();
    }
  }

  Widget _nfcLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(
          Icons.nfc,
          size: 20,
          color: Colors.blue,
        ),
        SizedBox(
          height: 10,
        ),
        Text("En attente du tag NFC")
      ],
    );
  }

  Widget _nfcSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(
          Icons.nfc,
          size: 20,
          color: Colors.green,
        ),
        SizedBox(
          height: 10,
        ),
        Text("Ecriture sur le tag NFC réussie")
      ],
    );
  }

  Widget _nfcError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(
          Icons.nfc,
          size: 20,
          color: Colors.red,
        ),
        SizedBox(
          height: 10,
        ),
        Text("Ecriture échouée")
      ],
    );
  }

  void _writer() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef != null && ndef.isWritable) {
        NdefMessage message = NdefMessage([
          NdefRecord.createText(""),
        ]);

        try {
          await ndef.write(message);
          NfcManager.instance.stopSession();
          setState(() {
            _status = NfcManagerStatus.success;
          });
          return;
        } catch (e) {
          NfcManager.instance
              .stopSession(errorMessage: result.value.toString());
          return;
        }
      }
    });
  }

  void _read() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);
      final garbage = Garbage.fromJson(json.decode(payloadAsString));
      print(garbage.salle);
      var ndef = Ndef.from(tag);
      if (ndef != null && ndef.isWritable) {
        NdefMessage message = NdefMessage([]);
        try {
          await ndef.write(message);
          NfcManager.instance.stopSession();
          setState(() {
            _status = NfcManagerStatus.success;
          });
          return;
        } catch (e) {
          NfcManager.instance
              .stopSession(errorMessage: result.value.toString());
          return;
        }
      }
      NfcManager.instance.stopSession();
    });
  }
}
