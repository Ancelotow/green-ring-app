import 'package:flutter/material.dart';
import 'package:green_ring/models/converter/color_converter.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/models/session.dart';
import 'package:green_ring/models/waste.dart';
import 'package:green_ring/services/service_api.dart';
import 'package:green_ring/ui/homepage.dart';
import 'package:green_ring/ui/widgets/garbage_item.dart';
import 'package:green_ring/ui/widgets/nfc_reader_garbage.dart';

class GarbagePage extends StatefulWidget {
  static const String routeName = "GarbagePage";
  final List<Waste> wastes;


  GarbagePage({Key? key, required this.wastes}) : super(key: key);

  @override
  State<GarbagePage> createState() => _GarbagePageState();
}

class _GarbagePageState extends State<GarbagePage> {
  Color? selectedColor;
  ServiceAPI service = ServiceAPI();
  List<Waste> _waste = [];

  @override
  Widget build(BuildContext context) {
    _waste = widget.wastes;

    return Scaffold(
      appBar: AppBar(title: const Text('Verification'),),
      body: SafeArea(
          child: Column(
        children: [
          Container(
              margin: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child:
              const Text('Veuillez vérifier qu\'il n\'y a pas d\'erreur.', style: TextStyle(fontSize: 18, color: Colors.black87),)),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _waste.length,
              itemBuilder: (context, index) =>
                  NotificationListener<SubmitNotification<Color>>(
                onNotification: (notification) {
                  setState(() {
                    _waste[index].trashColor = ColorConverter().toStringColor(notification.value);
                  });
                  return true;
                },
                child: GarbageItem(waste: _waste[index]),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () => _scanTrashes(context),
              child: const Text("Valider")),
        ],
      )),
    );
  }

  Future<void> _addPoints() async {
    Session.instance()!.user.coins++;
    print(Session.instance()!.user.coins);
    await service.addCoin(Session.instance()!.user.id);
  }

  void _scanTrashes(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<String>>(
                  child: NfcReaderGarbage(
                    wastes: _waste,
                  ),
                  onNotification: (notification) {
                    setState(() {
                      int counter = 0;
                      _waste.removeWhere((element) {
                        if ( element.trashColor == notification.value) {
                          counter++;
                          _addPoints();
                          return true;
                        }
                        return false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('+ $counter points ! 🎉'),
                      ));
                    });
                    if (_waste.isEmpty) {
                      Navigator.pop(context);
                      Navigator.of(context).popUntil(ModalRoute.withName(Homepage.routeName));
                    }
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
