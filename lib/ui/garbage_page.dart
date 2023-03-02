import 'package:flutter/material.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/models/waste.dart';
import 'package:green_ring/ui/widgets/garbage_item.dart';
import 'package:green_ring/ui/widgets/nfc_reader_garbage.dart';

class GarbagePage extends StatefulWidget {
  static String routeName = "GarbagePage";

  const GarbagePage({Key? key}) : super(key: key);

  @override
  State<GarbagePage> createState() => _GarbagePageState();
}

class _GarbagePageState extends State<GarbagePage> {
  Color? selectedColor;

  final List<Waste> _waste = [
    Waste(trashColor: "green", shape: "Bottle", material: "Plastic"),
    Waste(trashColor: "yellow", shape: "Bouchon", material: "Plastic"),
    Waste(trashColor: "yellow", shape: "Bouchon", material: "Plastic"),
    Waste(trashColor: "yellow", shape: "Bouchon", material: "Plastic"),
    Waste(trashColor: "yellow", shape: "Bouchon", material: "Plastic"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          Container(
              margin: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child:
                  const Text('Veuillez vérifier qu\'il n\'y a pas d\'erreur.')),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _waste.length,
              itemBuilder: (context, index) =>
                  GarbageItem(waste: _waste[index]),
            ),
          ),
          ElevatedButton(onPressed: () => _scanTrashes(context), child: const Text("Valider")),
        ],
      )),
    );
  }

  void _scanTrashes(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<String>>(
                  child: NfcReaderGarbage(wastes: _waste,),
                  onNotification: (notification) {
                    // Navigator.of(context).pop();
                    setState(() {
                      _waste.removeWhere((element) => element.trashColor == notification.value);
                    });

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

}

/*
Container(
              margin: const EdgeInsets.all(5.0),
              height: 120.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final color = colors[index];
                  final isSelected = selectedColor == color;

                  return SizedBox(
                    width: 80,
                    height: 120,
                    child: Card(
                      elevation: isSelected ? 5 : 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Center(child: Icon(
                          Icons.delete,
                          color:  color,
                          semanticLabel: "",),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
*/
