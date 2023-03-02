import 'dart:ui';

import 'package:green_ring/models/converter/color_converter.dart';

class Garbage {

  String id;
  String site;
  String salle;
  Color couleur;

  Garbage({
    required this.id,
    required this.site,
    required this.salle,
    required this.couleur,
  });

  Map<String, dynamic> toJson() => {
    "_id": id,
    "site": site,
    "room": salle,
    "color": ColorConverter().toStringColor(couleur)
  };

  Garbage.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        site = json['site'],
        salle = json['room'],
        couleur = ColorConverter().toColor(json['color']);

}
