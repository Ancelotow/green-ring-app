import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/models/session.dart';
import 'package:green_ring/models/user.dart';
import 'package:green_ring/ui/widgets/nfc_writer.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ConnectDistributor extends StatefulWidget {
  static String routeName = "ConnectDistributor";

  const ConnectDistributor({Key? key}) : super(key: key);


  @override
  State<ConnectDistributor> createState() => _ConnectDistributorState();
}

class _ConnectDistributorState extends State<ConnectDistributor> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Distributeur'),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Center(child: Icon(Icons.nfc, size: 200,color: Colors.grey.shade600,)))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _scanDistributor(context),
          tooltip: 'Scan',
          child: const Icon(Icons.qr_code_2_outlined),
        ),);
  }


  void _scanDistributor(BuildContext context) {
    User user = Session.instance()!.user;
    final jsonUser = '{"_id": "${user.id}"}';
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<void>>(
                  child: NfcWriter(
                    tagValue: jsonUser,
                  ),
                  onNotification: (notification) {
                    Navigator.pop(context, true);
                    return true;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

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
