import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:green_ring/models/nfc_manager_status.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcReaderGarbage extends StatefulWidget {
  const NfcReaderGarbage({Key? key}) : super(key: key);

  @override
  State<NfcReaderGarbage> createState() => _NfcReaderGarbageState();
}

class _NfcReaderGarbageState extends State<NfcReaderGarbage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  NfcManagerStatus _status = NfcManagerStatus.loading;

  @override
  Widget build(BuildContext context) {
    print('HERE: $_status');

    if(_status == NfcManagerStatus.loading) {
      _reader();
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
      children: const [
        Icon(
          Icons.nfc,
          size: 20,
          color: Colors.blue,
        ),
        SizedBox(height: 10,),
        Text("En attente du tag NFC")
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
      return;
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
      print(payload);
      print(payloadAsString);
      NfcManager.instance.stopSession();
    });
  }
}

