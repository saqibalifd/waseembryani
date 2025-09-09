import 'package:flutter/material.dart';
import 'package:waseembrayani/core/utils/consts.dart';

class CategoriesCard extends StatelessWidget {
  final bool isSelected;
  final String categoryImage;
  final String categoryName;
  const CategoriesCard({
    super.key,
    required this.isSelected,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 130,
      decoration: BoxDecoration(
        color: isSelected ? red : grey1,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            categoryImage,
            height: 40,
            width: 40,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood),
          ),
          SizedBox(width: 5),
          Text(
            categoryName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
