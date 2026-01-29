// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';
import '../../constants/app_colors.dart';

import 'package:myapp/services/seeder_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  String name = '';
  String price = '';
  String quantity = '';
  String _selectedCategory = 'groceries';
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

    try {
      final product = Product(
        id: const Uuid().v4(),
        name: name.trim(),
        price: double.parse(price),
        quantity: int.parse(quantity),
        category: _selectedCategory,
        imageUrl: '',
      );

      await ProductService().addProduct(product, _imageFile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Seed Default Inventory',
            onPressed: () async {
              setState(() => _isLoading = true);
              try {
                await SeederService().seedProducts();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inventory Seeded Successfully!'),
                    ),
                  );
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Seed Failed: $e')));
                }
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                onChanged: (val) => name = val,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) => price = val,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (double.tryParse(val) == null)
                          return 'Invalid price';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => quantity = val,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (int.tryParse(val) == null) return 'Invalid qty';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items:
                    ['Groceries', 'Clothing', 'Accessories']
                        .map(
                          (label) => DropdownMenuItem(
                            value: label.toLowerCase(),
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Save Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          image:
              _imageFile != null
                  ? DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child:
            _imageFile == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to add photo',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                )
                : Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
