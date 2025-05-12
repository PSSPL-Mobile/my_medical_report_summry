// App-wide constants for consistent styling and theming across the app.
import 'package:flutter/material.dart';

/// Name : AppConstants
/// Author : Prakash Software Pvt Ltd
/// Date : 02 May 2025
/// Desc : Defines static constants for colors, padding, and other styling properties.
class AppConstants {
  // Primary color used for app bars, buttons, and other primary elements.
  static const primaryColor = Colors.blue;

  // Secondary color used for accents and secondary elements.
  static const secondaryColor = Colors.teal;

  // Background color for sections like graph, tips, and reports (white).
  static const sectionColor = Colors.white;

  // Background color for cards (grey).
  static const cardColor = Colors.grey;

  // Default padding value used throughout the app (16.0).
  static const padding = 16.0;

  // Default border radius for rounded corners (8.0).
  static const borderRadius = 8.0;

  // Background color for the entire app (light grey-blue, 0xFFEFF2F4).
  static const bgColor = Color(0xFFEFF2F4);

  // Color for the graph line (blue, 0xFF2196F3).
  static const graphLineColor = Color(0xFF2196F3);

  // Background color for tip cards (soft mint blue, 0xFFEFF6FF).
  static const tipCardColor = Color(0xFFEFF6FF);

  // Color for metric labels and values (dark grey, 0xFF4B5563).
  static const metricsColor = Color(0xFF4B5563);

  // Color for date text (medium grey, 0xFF6B7280).
  static const dateColor = Color(0xFF6B7280);
}