import 'package:flutter/foundation.dart';
import 'package:myapp/models/product_model.dart';

class CartService with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get cartItems => _items;

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.price * item.quantity);

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
