import 'package:flutter/material.dart';

class InfoError extends StatelessWidget {

  final Error error;

  const InfoError({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        )
      ],
    );
  }
}