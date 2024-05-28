// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  DrawerItem({
    Key? key,
    required this.itemName,
    required this.icon,
    this.onPressed,
    this.onTap,
  }) : super(key: key);
  final String itemName;
  final IconData icon;
  void Function()? onPressed;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        child: ListTile(
          leading: Icon(
            icon,
            size: 26,
          ),
          title: Text(
            itemName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
