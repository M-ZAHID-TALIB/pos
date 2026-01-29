import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:myapp/models/product_model.dart';

class InvoiceService {
  Future<Uint8List> generateInvoiceBytes(List<Product> cartItems) async {
    final pdf = pw.Document();

    double total = cartItems.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  headers: ['Product', 'Qty', 'Price', 'Subtotal'],
                  data:
                      cartItems.map((item) {
                        final subtotal = item.quantity * item.price;
                        return [
                          item.name,
                          '${item.quantity}',
                          '\$${item.price}',
                          '\$${subtotal.toStringAsFixed(2)}',
                        ];
                      }).toList(),
                ),
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );

    return pdf.save();
  }

  Future<void> printInvoice(List<Product> cartItems) async {
    final bytes = await generateInvoiceBytes(cartItems);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }
}
