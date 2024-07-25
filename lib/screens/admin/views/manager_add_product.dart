import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/service/admin/category_service.dart';
import 'package:shop/service/admin/product_service.dart';

HttpClient createHttpClient() {
  final client = HttpClient();
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return client;
}

class ManagerAddProduct extends StatefulWidget {
  @override
  _ManagerAddProductState createState() => _ManagerAddProductState();
}

class _ManagerAddProductState extends State<ManagerAddProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _percentSaleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryIDController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  List<CategoryModel2> _categories = []; // Danh sách các danh mục
  int? _selectedCategoryID;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Lấy danh sách danh mục khi khởi tạo
  }

  void _fetchCategories() async {
    final param = {"currentPage": 1, "pageSize": 1000, "textSearch": ""};
    final res = await CategoryService().getCategories(param);
    if (res.isNotEmpty) {
      setState(() {
        _categories = res;
      });
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
    _categoryIDController.dispose();
    super.dispose();
  }

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
          _imageUrls.add(imageUrl);
          _imageUrlController.text = _imageUrls.join(', ');
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

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
      _imageUrlController.text = _imageUrls.join(',');
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageUrls.isNotEmpty) {
        // Xử lý khi form hợp lệ
        // Bạn có thể gọi API hoặc làm bất cứ gì bạn muốn với dữ liệu
        final newProduct = {
          "productID": 0,
          'productName': _productNameController.text,
          'totalAmount': int.parse(_totalAmountController.text),
          'price': int.parse(_priceController.text),
          'percentSale': int.parse(_percentSaleController.text),
          'description': _descriptionController.text,
          'imageUrl': _imageUrlController.text,
          'categoryID': _selectedCategoryID,
        };
        final success =
        await ProductService().insertOrUpdateProductAsync(newProduct);
        if (success) {
          Navigator.pop(context, 'add');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm mới sản phẩm thất bại!')),
          );
        }
      } else {
        print('Image URLs are empty');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm mới'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _totalAmountController,
                decoration: InputDecoration(labelText: 'Số lượng trong kho'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số lượng';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá bán'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá bán';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _percentSaleController,
                decoration: InputDecoration(labelText: 'Phần trăm giảm giá'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập phần trăm giảm giá';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedCategoryID,
                decoration: InputDecoration(labelText: 'Danh mục'),
                items: _categories.map((CategoryModel2 category) {
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
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn danh mục';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              _imageUrls.isNotEmpty
                  ? Container(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.network(
                          _imageUrls[index],
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeImage(index),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
                  : Text('No images selected.'),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Chọn ảnh'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Thêm sản phẩm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
