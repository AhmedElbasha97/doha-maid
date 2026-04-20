import 'package:flutter/material.dart';

class DrawerItemModel {
  final String id;
  final String title;
  final IconData icon;
  final List<DrawerItemModel>? children;

  const DrawerItemModel({
    required this.id,
    required this.title,
    required this.icon,
    this.children,
  });
}
