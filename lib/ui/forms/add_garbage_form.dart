import 'package:flutter/material.dart';
import 'package:green_ring/models/converter/color_converter.dart';
import 'package:green_ring/models/garbage.dart';
import 'package:green_ring/models/notifications/submit_notification.dart';

class AddGarbageForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController ctrlSite = TextEditingController();
  final TextEditingController ctrlSalle = TextEditingController();
  final TextEditingController ctrlColor = TextEditingController();
  Color? _colorSelected;

  AddGarbageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Ajout d'une poubelle"
          ),
          const SizedBox(height: 20,),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Site"
            ),
            validator: _textFieldValidator,
            controller: ctrlSite,
          ),
          const SizedBox(height: 20,),
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Salle"
            ),
            validator: _textFieldValidator,
            controller: ctrlSalle,
          ),
          const SizedBox(height: 20,),
          DropdownButtonFormField<Color>(
            decoration: const InputDecoration(
                labelText: "Couleur"
            ),
            validator: _dropdownButtonColorValidator,
            items: _getItems(),
            onChanged: (value) => _colorSelected = value,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () => _submit(context),
              child: const Text("Ajouter")
          ),
        ],
      ),
    );
  }

  String? _textFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Saisissez un texte';
    }
    return null;
  }

  String? _dropdownButtonColorValidator(Color? value) {
    if (value == null) {
      return 'Sélectionnez une couleur';
    }
    return null;
  }

  List<DropdownMenuItem<Color>> _getItems() {
    List<DropdownMenuItem<Color>> list = [];
    ColorConverter().getColors().forEach((key, value) {
      list.add(DropdownMenuItem<Color>(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              color: value,
            ),
            const SizedBox(width: 20,),
            Text(
              key,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ));
    });
    return list;
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var garbage = Garbage(
          id: '-1',
          site: ctrlSite.text,
          salle: ctrlSalle.text,
          couleur: _colorSelected!
      );
      SubmitNotification(garbage).dispatch(context);
    }
  }
}
