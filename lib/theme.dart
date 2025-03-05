import 'package:flutter/material.dart';

final defaultInputDecoration = InputDecoration(
  filled: true,
  hintStyle: const TextStyle(color: Color(0xFF757575)),
  fillColor: const Color(0xFF979797).withAlpha(30),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  ),
  enabledBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  ),
);
