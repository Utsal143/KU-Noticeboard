import 'package:flutter/material.dart';

class CategoryTag extends StatelessWidget {
  final String name;
  final bool isSelected;

  const CategoryTag({
    Key? key,
    required this.name,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(name, style: TextStyle(color: Colors.white)),
        backgroundColor: isSelected ? Colors.indigo[700] : Colors.indigo[900],
      ),
    );
  }
}
