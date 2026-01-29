import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';
import 'package:myapp/screens/products/add_product_screen.dart';
import 'package:myapp/screens/cart/cart_screen.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/services/cart_service.dart';
import '../../constants/app_colors.dart';

class ProductListScreen extends StatelessWidget {
  final bool isPOSMode;

  const ProductListScreen({super.key, this.isPOSMode = false});

  void _deleteProduct(BuildContext context, String productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await ProductService().deleteProduct(productId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<CartService>().addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<AuthProvider>().user?.role ?? 'staff';
    final isAdmin = userRole == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPOSMode ? 'New Sale' : 'Inventory'),
        actions: [
          if (isPOSMode)
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
            ),
        ],
      ),
      floatingActionButton:
          isPOSMode
              ? FloatingActionButton.extended(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('View Cart'),
                backgroundColor: AppColors.accent,
              )
              : (isAdmin
                  ? FloatingActionButton.extended(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddProductScreen(),
                          ),
                        ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  )
                  : null),
      body: StreamBuilder<List<Product>>(
        stream: ProductService().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.only(
              bottom: 80,
              left: 16,
              right: 16,
              top: 16,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: InkWell(
                  onTap: isPOSMode ? () => _addToCart(context, product) : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child:
                                  product.imageUrl.isNotEmpty
                                      ? (product.imageUrl.startsWith('http')
                                          ? Image.network(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                          )
                                          : Image.asset(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                color: AppColors.primary
                                                    .withAlpha(20),
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: AppColors.danger,
                                                ),
                                              );
                                            },
                                          ))
                                      : Container(
                                        color: AppColors.primary.withAlpha(20),
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: AppColors.primary,
                                        ),
                                      ),
                            ),
                            if (!isPOSMode && isAdmin)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: PopupMenuButton<String>(
                                    onSelected:
                                        (value) =>
                                            value == 'delete'
                                                ? _deleteProduct(
                                                  context,
                                                  product.id,
                                                )
                                                : null,
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    itemBuilder:
                                        (ctx) => [
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Qty: ${product.quantity}',
                                  style: TextStyle(
                                    color:
                                        product.quantity < 5
                                            ? AppColors.danger
                                            : AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
