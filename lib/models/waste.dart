
class Waste {
  String trashColor;
  String shape;
  String material;

  Waste({
    required this.trashColor,
    required this.shape,
    required this.material,
  });

  Map<String, dynamic> toJson() => {
    "trashColor": trashColor,
    "shape": shape,
    "material": material
  };

  Waste.fromJson(Map<String, dynamic> json)
      : trashColor = json['trashColor'],
        shape = json['shape'],
        material = json['material'];
}