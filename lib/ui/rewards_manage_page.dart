import 'package:flutter/material.dart';
import 'package:green_ring/models/product.dart';
import 'package:green_ring/ui/widgets/info_error.dart';
import '../models/notifications/submit_notification.dart';
import '../services/service_api.dart';
import 'forms/reward_form.dart';

class RewardsManagePage extends StatefulWidget {
  const RewardsManagePage({Key? key}) : super(key: key);

  @override
  State<RewardsManagePage> createState() => _RewardsManagePageState();
}

class _RewardsManagePageState extends State<RewardsManagePage> {
  List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin - Récompenses",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder(
              future: ServiceAPI().getRewards(),
              builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  _products = snapshot.data!;
                  return _getBody(context);
                } else if (snapshot.hasError) {
                  return InfoError(error: snapshot.error as Error);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      semanticsLabel: "Chargement en cours...",
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _getFloatingButtonAction(context),
    );
  }

  Widget _getBody(BuildContext context) {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final item = _products[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "${item.price} points"
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton _getFloatingButtonAction(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addGarbageForm(context),
      tooltip: 'Ajouter la récompense',
      child: const Icon(Icons.add),
    );
  }

  void _addGarbageForm(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                content: NotificationListener<SubmitNotification<Product>>(
                  child: RewardForm(),
                  onNotification: (notification) {
                    ServiceAPI().addProduct(notification.value).then((value) {
                      Navigator.pop(context, value);
                    });
                    return true;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      _products.add(result);
    });
  }
}
