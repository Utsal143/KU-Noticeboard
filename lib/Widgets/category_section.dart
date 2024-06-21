import 'package:flutter/material.dart';
import 'package:notices_app/Widgets/category_tag.dart';

class CategorySection extends StatefulWidget {
  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  List<String> categories = ['Departmental', 'Exam', 'Result', 'Events'];
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          bool isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = isSelected ? '' : category;
              });
            },
            child: CategoryTag(
              name: category,
              isSelected: isSelected,
            ),
          );
        }).toList(),
      ),
    );
  }
}
