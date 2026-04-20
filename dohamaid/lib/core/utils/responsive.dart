import 'package:flutter/material.dart';

/// Helper to easily get screen width & height anywhere in your app.
double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;
double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;
