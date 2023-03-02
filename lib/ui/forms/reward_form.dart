import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_ring/models/product.dart';

import '../../models/notifications/submit_notification.dart';

class RewardForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlPrice = TextEditingController();

  RewardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Ajout d'une récompense"),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Nom"),
            validator: _textFieldValidator,
            controller: ctrlName,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Prix"),
            keyboardType: TextInputType.number,
            validator: _textFieldNumberValidator,
            controller: ctrlPrice,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () => _submit(context), child: const Text("Ajouter")),
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

  String? _textFieldNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Saisissez un prix';
    }
    return null;
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var product = Product(
        id: "",
        name: ctrlName.text,
        price: int.parse(ctrlPrice.text)
      );
      SubmitNotification(product).dispatch(context);
    }
  }
}
