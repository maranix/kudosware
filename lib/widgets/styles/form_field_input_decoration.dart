import 'package:flutter/material.dart';

InputDecoration textFieldDecoration({
  bool enabled = true,
  String? labelText,
  String? hintText,
}) {
  return InputDecoration(
    enabled: enabled,
    labelText: labelText,
    hintText: hintText,
    border: const OutlineInputBorder(),
  );
}
