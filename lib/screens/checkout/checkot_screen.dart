import 'package:flutter/material.dart';
import 'package:myapp/services/cart_service.dart';
import 'package:myapp/services/invoice_service.dart';
//import 'package:myapp/services/bluetooth_printer_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/product_model.dart'; // Import your Product model

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<void> _placeOrder() async {
    final cart = context.read<CartService>();

    if (cart.cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty.")));
      return;
    }

    try {
      final orderData = {
        'items':
            cart.cartItems
                .map(
                  (item) => {
                    'id': item.id,
                    'name': item.name,
                    'price': item.price,
                    'quantity': item.quantity,
                  },
                )
                .toList(),
        'total': cart.totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);
      cart.clearCart();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to place order: $e")));
    }
  }

  Future<void> _generateInvoice() async {
    final cart = context.read<CartService>();

    if (cart.cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty.")));
      return;
    }

    try {
      final invoiceService = InvoiceService();

      // Convert CartItem to Product including imageUrl
      List<Product> products =
          cart.cartItems
              .map(
                (cartItem) => Product(
                  id: cartItem.id,
                  name: cartItem.name,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  imageUrl: cartItem.imageUrl, // Added here
                ),
              )
              .toList();

      await invoiceService.printInvoice(products);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invoice generated and printing...")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invoice generation failed: $e")));
    }
  }

  Future<void> _printBluetoothReceipt() async {
    final cart = context.read<CartService>();

    if (cart.cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty.")));
      return;
    }

    try {
      //final printer = BluetoothPrinterService();
      //await printer.printReceipt(cart.cartItems, cart.totalPrice);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Receipt sent to printer.")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Bluetooth printing failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cart.cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      '${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '\$${(item.quantity * item.price).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _placeOrder,
                    icon: const Icon(Icons.check),
                    label: const Text('Place Order'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateInvoice,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Invoice'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _printBluetoothReceipt,
              icon: const Icon(Icons.print),
              label: const Text('Print Receipt'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
