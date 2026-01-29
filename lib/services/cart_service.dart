import 'package:flutter/foundation.dart';

import 'package:myapp/models/product_model.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get cartItems => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addToCart(Product product) {
    // Check if item exists
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      // Update quantity
      var existing = _items[index];
      _items[index] = CartItem(
        id: existing.id,
        name: existing.name,
        price: existing.price,
        quantity: existing.quantity + 1,
        imageUrl: existing.imageUrl,
        category: existing.category,
      );
    } else {
      // Add new
      _items.add(
        CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: 1,
          imageUrl: product.imageUrl,
          category: product.category,
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void incrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      var existing = _items[index];
      _items[index] = CartItem(
        id: existing.id,
        name: existing.name,
        price: existing.price,
        quantity: existing.quantity + 1,
        imageUrl: existing.imageUrl,
        category: existing.category,
      );
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        var existing = _items[index];
        _items[index] = CartItem(
          id: existing.id,
          name: existing.name,
          price: existing.price,
          quantity: existing.quantity - 1,
          imageUrl: existing.imageUrl,
          category: existing.category,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
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
  final String category; // Added category
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.category = 'General', // Added category with default
    required this.imageUrl,
  });
}
