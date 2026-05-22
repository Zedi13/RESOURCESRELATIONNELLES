import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });
}
