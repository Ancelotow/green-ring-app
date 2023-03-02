import 'package:flutter/material.dart';
import 'package:green_ring/models/nfc_manager_status.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../models/notifications/submit_notification.dart';

class NfcWriter extends StatefulWidget {
  final String tagValue;

  const NfcWriter({
    Key? key,
    required this.tagValue,
  }) : super(key: key);

  @override
  State<NfcWriter> createState() => _NfcWriterState();
}

class _NfcWriterState extends State<NfcWriter> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  NfcManagerStatus _status = NfcManagerStatus.loading;

  @override
  Widget build(BuildContext context) {
    if(_status == NfcManagerStatus.loading) {
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
        SizedBox(height: 10,),
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
        SizedBox(height: 10,),
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
        SizedBox(height: 10,),
        Text("Ecriture échouée")
      ],
    );
  }

  void _writer() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef != null && ndef.isWritable) {
        NdefMessage message = NdefMessage([
          NdefRecord.createText(widget.tagValue),
        ]);

        try {
          await ndef.write(message);
          NfcManager.instance.stopSession();
          setState(() {
            _status = NfcManagerStatus.success;
          });
          return;
        } catch (e) {
          NfcManager.instance.stopSession(errorMessage: result.value.toString());
          return;
        }
      }
    });
  }
}
