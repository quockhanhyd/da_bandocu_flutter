import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/models/category_model.dart'; // Thay thế bằng đường dẫn chính xác của bạn
import 'package:shop/service/admin/category_service.dart';
import 'package:shop/service/admin/product_service.dart';

import '../../../models/product_model.dart';
import 'components/ProductItem.dart';

class ProductDetailAdminScreen extends StatefulWidget {
  final ProductModel2 product;

  ProductDetailAdminScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailAdminScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _totalAmountController;
  late TextEditingController _priceController;
  late TextEditingController _percentSaleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  int? _selectedCategoryID;
  List<CategoryModel2> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.product.productName);
    _totalAmountController =
        TextEditingController(text: widget.product.totalAmount.toString());
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _percentSaleController =
        TextEditingController(text: widget.product.percentSale.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
    _selectedCategoryID = widget.product.categoryID;

    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categoryService = CategoryService();
      final param = {"currentPage": 1, "pageSize": 1000, "textSearch": ""};
      final categories = await categoryService.getCategories(param);
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _totalAmountController.dispose();
    _priceController.dispose();
    _percentSaleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Thực hiện công việc bất đồng bộ sau khi cập nhật trạng thái
      await _uploadImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      print('No image selected.');
      return;
    }

    try {
      final ioClient = IOClient(createHttpClient());

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://192.168.0.107:7156/api/Upload/upload'),
      );

      request.files
          .add(await http.MultipartFile.fromPath('file', _image!.path));

      final response = await ioClient.send(request);

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response: $responseBody');
        final decodedResponse = jsonDecode(responseBody);
        final imageUrl = decodedResponse['data']; // Nhận URL từ phản hồi

        setState(() {
          _imageUrlController.text = imageUrl;
        });
      } else {
        print('Image upload failed with status: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  double _calculateDiscountedPrice() {
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final double percentSale =
        double.tryParse(_percentSaleController.text) ?? 0.0;
    return price - (percentSale / 100 * price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final productId = widget.product.productID;

              try {
                final productService = ProductService();
                final success = await productService.deleteProduct(productId);
                if (success) {
                  Navigator.pop(context, 'deleted');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa thất bại!')),
                  );
                }
              } catch (e) {
                print('Failed to delete product: $e');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _totalAmountController,
                    decoration:
                        InputDecoration(labelText: 'Số lượng trong kho'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Giá bán'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _percentSaleController,
                    decoration:
                        InputDecoration(labelText: 'Phần trăm giảm giá'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Giá sau khi giảm: ${(_calculateDiscountedPrice()).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Mô tả'),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryID,
                    items: _categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.categoryID,
                        child: Text(category.categoryName ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryID = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Danh mục'),
                  ),
                  SizedBox(height: 10),
                  if (_imageUrlController.text.isNotEmpty)
                    Center(
                      child: Image.network(
                        _imageUrlController.text,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 50, color: Colors.grey);
                        },
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Chọn ảnh mới'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final product = {
                        "productID": widget.product.productID,
                        'productName': _productNameController.text,
                        'totalAmount': int.parse(_totalAmountController.text),
                        'price': int.parse(_priceController.text),
                        'percentSale': int.parse(_percentSaleController.text),
                        'description': _descriptionController.text,
                        'imageUrl': _imageUrlController.text,
                        'categoryID': _selectedCategoryID,
                      };

                      try {
                        final productService = ProductService();
                        final success = await productService
                            .insertOrUpdateProductAsync(product);
                        if (success) {
                          Navigator.pop(context, 'updated');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Cập nhật sản phẩm thất bại!')),
                          );
                        }
                      } catch (e) {
                        print('Failed to update product: $e');
                      }
                    },
                    child: Text('Cập nhật sản phẩm'),
                  ),
                ],
              ),
            ),
    );
  }
}
