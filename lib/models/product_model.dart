// lib/models/product_model.dart

class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  // Create a Product object from Firestore map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 0),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Convert Product object to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
