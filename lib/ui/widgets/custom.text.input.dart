// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextInput extends StatelessWidget {
  CustomTextInput(
      {super.key,
      this.onIsTyping,
      required this.controller,
      this.onEditingComplete,
      this.onTapOutside});
  void Function(String)? onIsTyping;
  void Function(PointerDownEvent)? onTapOutside;
  void Function()? onEditingComplete;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onChanged: onIsTyping,
      style: TextStyle(fontSize: 20, color: Colors.grey[800]),
      decoration: InputDecoration(
        prefixIcon: Icon(
          FontAwesomeIcons.city,
          size: 18,
          color: Colors.grey[500],
        ),
        fillColor: Colors.grey[200],
        border: InputBorder.none,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: "Ajouter une ville",
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
      ),
    );
  }
}
