import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderCard extends StatelessWidget {
  HeaderCard(
      {super.key,
      required this.title,
      required this.minTemp,
      required this.maxTemp});
  String title;
  double minTemp;
  double maxTemp;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            subtitle: Text("Min: $minTemp°C - Max: $maxTemp°C"),
          ),
        ],
      ),
    );
  }
}
