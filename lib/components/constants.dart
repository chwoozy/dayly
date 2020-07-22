import 'package:flutter/material.dart';

// Colors
const primaryBackgroundColor = Color(0xFFF3F2F9);
const primaryPurple = Color(0xFF6F35A5);
const primaryLightColor = Color(0xFFF1E6FF);
const secondaryBackgroundColor = Color(0xFFE7E4F3);

// Decorations
var authTextInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.circular(29),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryPurple, width: 2.0),
    borderRadius: BorderRadius.circular(29),
  ),
);
