import 'package:flutter/material.dart';
import 'package:green_ring/models/converter/color_converter.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';
import 'package:green_ring/models/waste.dart';

class GarbageItem extends StatefulWidget {
  final Waste waste;

  const GarbageItem({Key? key, required this.waste}) : super(key: key);

  @override
  State<GarbageItem> createState() => _GarbageItemState();
}

class _GarbageItemState extends State<GarbageItem> {
  Color? selectedColor;

  final List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.brown
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = ColorConverter().getColors()[widget.waste.trashColor];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 0.5),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0)
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text('${widget.waste.shape} ${widget.waste.material}', style: TextStyle(fontSize: 18, color: Colors.black87),),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
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
                        SubmitNotification(color).dispatch(context);
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          color: color,
                          semanticLabel: "",
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
