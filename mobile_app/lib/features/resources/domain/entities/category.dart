import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String colorHex;
  final String iconName;
  final int ordre;
  final bool estActive;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    this.colorHex = '#607D8B',
    this.iconName = 'category',
    this.ordre = 0,
    this.estActive = true,
  });

  Category copyWith({
    String? name,
    String? description,
    Color? color,
    IconData? icon,
    String? colorHex,
    String? iconName,
    int? ordre,
    bool? estActive,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
      ordre: ordre ?? this.ordre,
      estActive: estActive ?? this.estActive,
    );
  }
}
