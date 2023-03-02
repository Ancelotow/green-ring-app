import 'dart:ui';

import 'package:green_ring/models/converter/color_converter.dart';

class Garbage {

  int id;
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
    "id": id,
    "site": site,
    "salle": salle,
    "couleur": ColorConverter().toStringColor(couleur)
  };

  Garbage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        site = json['site'],
        salle = json['salle'],
        couleur = ColorConverter().toColor(json['couleur']);

}
