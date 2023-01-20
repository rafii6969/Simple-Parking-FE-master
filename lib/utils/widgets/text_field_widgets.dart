// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_parking_app/utils/colors_theme.dart';

class AddVehicleTextField extends StatelessWidget {
  const AddVehicleTextField({
    required this.controller,
    required this.title,
  });

  final TextEditingController controller;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        controller: controller,
        autocorrect: false,
        cursorColor: ColorsTheme.myOrange,
        decoration: InputDecoration(
          hintText: "Ex: $title",
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.myOrange),
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    required this.controller,
    required this.editable,
    required this.title,
    required this.inputType,
  });

  final TextEditingController controller;
  final RxBool editable;
  final String title;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(
        () => TextField(
          controller: controller,
          cursorHeight: 20,
          obscureText: isobscureText(),
          cursorColor: ColorsTheme.myOrange,
          keyboardType: inputType,
          textAlign: TextAlign.end,
          autocorrect: false,
          style: TextStyle(color: ColorsTheme.myGrey),
          decoration: InputDecoration(
            prefix: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsTheme.myDarkBlue,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorsTheme.myOrange),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsTheme.myOrange),
            ),
            enabled: editable.value,
          ),
          //onChanged: (val) {},
        ),
      ),
    );
  }

  bool isobscureText() {
    if (title == "Password") {
      if (!editable.value) {
        return true;
      }
    }
    return false;
  }
}

class VehicleNumberTextField extends StatelessWidget {
  const VehicleNumberTextField({
    required this.controller,
    required this.hint,
    required this.width,
    required this.maxLength,
    this.inputType = TextInputType.name,
  });

  final TextEditingController controller;
  final String hint;
  final double width;
  final int maxLength;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: width,
        child: TextField(
          controller: controller,
          autocorrect: false,
          maxLength: maxLength,
          cursorColor: ColorsTheme.myOrange,
          textAlign: TextAlign.center,
          keyboardType: inputType,
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(
            counter: Offstage(),
            hintText: hint,
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey.shade200,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsTheme.myOrange),
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
