import 'package:flutter/material.dart';
import './text_field_box.dart';

class PhoneTextField extends StatelessWidget {
  final Color textFieldBoxColor;
  final bool isDisabled;
  final TextEditingController controller;
  final void Function(String) onChanged;
  const PhoneTextField(
      {Key? key, required this.controller, required this.textFieldBoxColor, this.isDisabled = false, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocNetTextFieldBox(
      color: isDisabled ? Colors.grey : textFieldBoxColor,
      textField: TextField(
        onChanged: onChanged,
        enabled: !isDisabled,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          counterText: "",
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 4.0, 4.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 54.0),
              child: Row(
                children: const [
                  Expanded(
                    child: Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    '+7',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        maxLength: 15,
        controller: controller,
      ),
    );
  }
}