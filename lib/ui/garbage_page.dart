import 'package:flutter/material.dart';
import 'package:green_ring/models/converter/color_converter.dart';
import 'package:green_ring/models/waste.dart';
import 'package:green_ring/ui/widgets/garbage_card.dart';
import 'package:green_ring/ui/widgets/icone_garbage.dart';
import 'package:select_card/select_card.dart';
import '../models/garbage.dart';

class GarbagePage extends StatefulWidget {
  static String routeName = "GarbagePage";

  const GarbagePage({Key? key}) : super(key: key);

  @override
  State<GarbagePage> createState() => _GarbagePageState();
}

class _GarbagePageState extends State<GarbagePage> {
  int selectedIndex = 0;

  Garbage? _selectedGarbage;
  final List<Waste> _waste = [
    Waste(trashColor: "vert", shape: "Bottle", material: "Plastic"),
  ];

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [Colors.grey, Colors.green, Colors.yellow, Colors.blue];
    //_selectedGarbage = Garbage(site: "site", salle: "salle", couleur: Colors.blue);
    // _waste = [Waste(trashColor: "Yellow", shape: "Bottle", material: "Plastic")];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        //IconGarbage(garbage: _selectedGarbage)
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 8.0, left: 8.0),
                // color: ColorConverter().toColor(_waste.first.trashColor),
                child: Text(_waste.first.shape),
              ),
            ),
            /*ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: SizedBox(
                      width: 80,
                      height: 120,
                      child: Center(child: Icon(
                        Icons.delete,
                        color:  colors[index],
                        semanticLabel: "",),
                      ),
                    ),
                  ),
                );
              },
            ),*/
            Container(
              margin: const EdgeInsets.all(5.0),
              height: 120.0,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Card(
                    child: InkWell(
                      onTap: () {
                      },
                      child: const SizedBox(
                        width: 80,
                        height: 120,
                        child: Center(child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                          semanticLabel: "",),
                      ),
                    ),
                  ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: InkWell(
                      onTap: () {
                        print("test");
                      },
                      child: const SizedBox(
                        width: 80,
                        height: 120,
                        child: Center(child: Icon(
                          Icons.delete,
                          color: Colors.green,
                          semanticLabel: "",),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        print("test");
                      },
                      child: const SizedBox(
                        width: 80,
                        height: 120,
                        child: Center(child: Icon(
                          Icons.delete,
                          color: Colors.yellow,
                          semanticLabel: "",),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        print("test");
                      },
                      child: const SizedBox(
                        width: 80,
                        height: 120,
                        child: Center(child: Icon(
                          Icons.delete,
                          color: Colors.blue,
                          semanticLabel: "",),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),



            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text("Bouchon"),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              height: 120.0,
              child: ListView(
                // This next line does the trick.
                shrinkWrap: true, //just set this property
                padding: const EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ElevatedCard(
                    garbage: _selectedGarbage,
                  ),
                  OutlinedCard(
                    garbage: _selectedGarbage,
                  ),
                  ElevatedCard(
                    garbage: _selectedGarbage,
                  ),
                  ElevatedCard(
                    garbage: _selectedGarbage,
                  ),
                  ElevatedCard(
                    garbage: _selectedGarbage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*ListView(
              // This next line does the trick.
              shrinkWrap: true, //just set this property
              padding: const EdgeInsets.all(8.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ElevatedCard(
                  garbage: _selectedGarbage,
                ),
                OutlinedCard(
                  garbage: _selectedGarbage,
                ),
                FilledCard(
                  garbage: _selectedGarbage,
                ),
                Container(
                  width: 160.0,
                  color: Colors.green,
                ),
                Container(
                  width: 160.0,
                  color: Colors.yellow,
                ),
                Container(
                  width: 160.0,
                  color: Colors.orange,
                ),
              ],
            )*/

/*
* ListView(
                shrinkWrap: true, //just set this property
                padding: const EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: [
                  SelectGroupCard(context,
                      titles: ColorConverter().getColors().keys.toList(),
                      ids: ids,
                      imageSourceType: ImageSourceType.network,
                      cardBackgroundColor: Colors.grey,
                      cardSelectedColor: Colors.green,
                      titleTextColor: Colors.white,
                      contentTextColor: Colors.white70, onTap: (title, id) {
                    debugPrint(title);
                    debugPrint(id);
                    setState(() {
                      singleCardResult = title;
                      _selectedGarbage?.couleur = ColorConverter().toColor(title);
                    });
                  }),
                ],
              )*/
