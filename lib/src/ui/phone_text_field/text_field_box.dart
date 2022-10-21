import 'package:flutter/material.dart';

class LocNetTextFieldBox extends StatelessWidget {
  final Color color;
  final TextField textField;
  const LocNetTextFieldBox(
      {Key? key, required this.color, required this.textField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10),
        height: 48.0,
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: textField);
  }
}
