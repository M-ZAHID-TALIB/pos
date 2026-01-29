import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/product_model.dart';

class SeederService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Map<String, List<String>> _assets = {
    'groceries': [
      'apples.png', 'bananas.png', 'bread.png', 'butter.png', 'cheese.png',
      'chicken.png', 'coffee.png', 'eggs.png', 'flour.png', 'lentils.png',
      // 'milk icon.webp', // skipping webp for simplicity or handling it separately
      'milk.png', 'oil.png', 'onions.png', 'potatos.png', 'rice.png',
      'salt.png', 'suger.png', 'tea.png', 'tomatos.png', 'yogurt.png',
    ],
    'clothing': [
      'belt.png',
      'blazer.png',
      'cap.png',
      'chinos.png',
      'formal_shirt.png',
      'gloves.png',
      'hoodie.png',
      'jacket.png',
      'jeans.png',
      'kurta.png',
      'polo_shirt.png',
      'scarf.png',
      'shalwar.png',
      'shawl.png',
      'skirt.png',
      'sneakers.png',
      'socks.png',
      'sweater.png',
      'track_pants.png',
      'tshirt.png',
    ],
    'accessories': [
      'backpack.png',
      'belt.png',
      'bracelet.png',
      'brooch.png',
      'duffel_bag.png',
      'earrings.png',
      'gloves.png',
      'hairband.png',
      'handbag.png',
      'keychain.png',
      'necklace.png',
      'pocket_square.png',
      'rings.png',
      'scarf_pin.png',
      'shoe_polish_kit.png',
      'sunglasses.png',
      'tie.png',
      'travel_pouch.png',
      'wallet.png',
      'watch.png',
    ],
  };

  Future<void> seedProducts() async {
    final batch = _db.batch();
    final random = Random();

    for (var entry in _assets.entries) {
      String category = entry.key;
      List<String> files = entry.value;

      for (var file in files) {
        String name = file.split('.').first.replaceAll('_', ' ').toUpperCase();
        // Check if exists first to avoid duplicates?
        // Batch write doesn't support query. We will just add.
        // For a cleaner seed, we might want to check, but for "Add Inventory" feature, just adding is okay.
        // Actually, let's use a deterministic ID based on name to avoid duplicates if re-run!

        String id = name.replaceAll(' ', '_').toLowerCase();

        // Random Price 5.00 to 100.00
        double price = (random.nextInt(95) + 5) + (random.nextInt(99) / 100);

        // Random Qty 10 to 100
        int quantity = random.nextInt(90) + 10;

        Product product = Product(
          id: id,
          name: name,
          price: double.parse(price.toStringAsFixed(2)),
          quantity: quantity,
          category: category,
          imageUrl: 'assets/$category/$file',
        );

        DocumentReference ref = _db.collection('products').doc(id);
        batch.set(ref, product.toMap());
      }
    }

    await batch.commit();
  }
}
