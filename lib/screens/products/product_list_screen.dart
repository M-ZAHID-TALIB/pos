import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';
import 'package:myapp/screens/products/add_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  void _deleteProduct(BuildContext context, String productId) async {
    await ProductService().deleteProduct(productId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Product deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddProductScreen()),
            ),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Product>>(
        stream: ProductService().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ListTile(
                leading:
                    product.imageUrl.isNotEmpty
                        ? Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : Icon(Icons.image),
                title: Text(product.name),
                subtitle: Text(
                  'Price: \$${product.price.toStringAsFixed(2)}  | Qty: ${product.quantity}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteProduct(context, product.id);
                    }
                    // Optional: Add 'edit' case if you support edit
                  },
                  itemBuilder:
                      (ctx) => [
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
