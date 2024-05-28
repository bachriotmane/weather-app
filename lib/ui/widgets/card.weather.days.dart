import 'package:flutter/material.dart';

class CardDayItem extends StatelessWidget {
  CardDayItem(
      {super.key,
      required this.day,
      required this.statusIcon,
      required this.statusText,
      required this.minTemp,
      required this.maxTemp});
  String day;
  Icon statusIcon;
  String statusText;
  double minTemp;
  double maxTemp;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Column(
            children: [
              Text(statusText),
              Text(
                "Min: $minTemp°C - Max: $maxTemp°C",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          statusIcon
        ],
      ),
    );
  }
}
