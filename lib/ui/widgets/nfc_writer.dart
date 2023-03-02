import 'package:flutter/material.dart';
import 'package:green_ring/models/nfc_manager_status.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
    _writer();
    return Container();
  }

  Widget _NfcLoading() {
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
        Text("En attente du NFC")
      ],
    );
  }

  Widget _NfcSuccess() {
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
        Text("Ecriture réussie")
      ],
    );
  }

  Widget _NfcError() {
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

  Future<bool> _writer() async {
    bool isValid = false;
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        NfcManager.instance.stopSession(errorMessage: result.value);
        isValid = false;
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(widget.tagValue),
      ]);

      try {
        await ndef.write(message);
        NfcManager.instance.stopSession();
        isValid = true;
        return;
      } catch (e) {
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        isValid = false;
        return;
      }
    });
    if(!isValid) {

    }
    return isValid;
  }
}
