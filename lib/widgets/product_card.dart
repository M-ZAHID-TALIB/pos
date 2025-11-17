import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  const ProductCard({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(title)),
    );
  }
}
