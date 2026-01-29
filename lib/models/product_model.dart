// lib/models/product_model.dart

class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String category; // Added category
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category, // Added category
    required this.imageUrl,
  });

  // Create a Product object from Firestore map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 0),
      category: map['category'] ?? 'General', // Added category
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
      'category': category, // Added category
      'imageUrl': imageUrl,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? category, // Added category
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category, // Added category
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
