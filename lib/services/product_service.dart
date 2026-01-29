import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/models/product_model.dart';

class ProductService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;
  final String _collection = 'products';

  Future<String> uploadImage(File imageFile) async {
    String fileId = Uuid().v4();
    Reference ref = _storage.ref().child('product_images/$fileId.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> addProduct(Product product, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }
    final newProduct = product.copyWith(imageUrl: imageUrl);
    await _db.collection(_collection).doc(product.id).set(newProduct.toMap());
  }

  Future<void> updateProduct(Product product, File? imageFile) async {
    String imageUrl = product.imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }
    final updatedProduct = product.copyWith(imageUrl: imageUrl);
    await _db
        .collection(_collection)
        .doc(product.id)
        .update(updatedProduct.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection(_collection).doc(productId).delete();
  }

  Stream<List<Product>> getProducts() {
    return _db.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
    });
  }

  Future<void> deductStock(List<Map<String, dynamic>> items) async {
    final batch = _db.batch();

    for (final item in items) {
      final String productId = item['id'];
      final int quantitySold = item['quantity'];

      final docRef = _db.collection(_collection).doc(productId);

      // We use FieldValue.increment with a negative value for atomic updates
      batch.update(docRef, {'quantity': FieldValue.increment(-quantitySold)});
    }

    await batch.commit();
  }
}
