import 'dart:ui';

import 'package:green_ring/models/converter/color_converter.dart';

class Garbage {
  String site;
  String salle;
  Color couleur;

  Garbage({
    required this.site,
    required this.salle,
    required this.couleur,
  });

  Map<String, dynamic> toJson() => {
    "site": site,
    "salle": salle,
    "couleur": ColorConverter().toStringColor(couleur)
  };
}
