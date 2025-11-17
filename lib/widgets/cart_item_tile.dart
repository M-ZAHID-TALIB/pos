import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final String item;
  const CartItemTile({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(item));
  }
}
