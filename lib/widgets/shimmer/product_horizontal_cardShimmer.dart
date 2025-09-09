import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton loader for Category Card
class ProductHorizontalCardshimmer extends StatelessWidget {
  const ProductHorizontalCardshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(child: SizedBox(height: 250, width: 200)),
        ),

        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(child: SizedBox(height: 250, width: 200)),
        ),
      ],
    );
  }
}
