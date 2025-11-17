import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  String name = '';
  String price = '';
  String quantity = '';
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final product = Product(
      id: const Uuid().v4(),
      name: name.trim(),
      price: double.parse(price),
      quantity: int.parse(quantity),
      imageUrl: '', // Will be handled by service
    );

    await ProductService().addProduct(product, _imageFile);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Product Added')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                onChanged: (val) => name = val,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (val) => price = val,
                validator:
                    (val) =>
                        val == null || double.tryParse(val) == null
                            ? 'Invalid price'
                            : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (val) => quantity = val,
                validator:
                    (val) =>
                        val == null || int.tryParse(val) == null
                            ? 'Invalid quantity'
                            : null,
              ),
              SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : Placeholder(fallbackHeight: 150),
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Select Image'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _submit,
                    child: Text('Add Product'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
