
class Waste {
  String trashColor;
  String shape;
  String material;

  Waste({
    required this.trashColor,
    required this.shape,
    required this.material,
  });

  Map<String, dynamic> fromJson() => {
    "trashColor": trashColor,
    "shape": shape,
    "material": material
  };
}

/*
[
    {
        "trashColor": "yellow",
        "shape": "tray",
        "material": "plastic"
    },
    {
        "trashColor": "yellow",
        "shape": "film",
        "material": "plastic"
    },
    {
        "trashColor": "blue",
        "shape": "cardboard",
        "material": "cardboard"
    }
]
 */