import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get cartItems => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addItem(CartItem item) {
    // Optional: You can add logic to increase quantity if item already exists
    _items.add(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl; // Added imageUrl

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl, // Required in constructor
  });
}
