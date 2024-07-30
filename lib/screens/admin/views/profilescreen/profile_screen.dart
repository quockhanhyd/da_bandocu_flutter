import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/user.dart'; // Đảm bảo rằng lớp User được định nghĩa chính xác ở đây

class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  _ProfileAdminScreenState createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      setState(() {
        _user = User.fromJson(jsonDecode(userJson));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _user == null
            ? Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn tải khi dữ liệu chưa sẵn sàng
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN-nni56QIaz-F9RYvtMXBz1ymWZo4d6gNsA&s'), // Thay thế bằng URL ảnh thực tế
            ),
            SizedBox(height: 20),
            // Thông tin cá nhân
            Text(
              _user?.fullName ?? 'Tên người dùng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${_user?.userName ?? 'N/A'}', // Hiển thị email người dùng
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Vai trò: ${_user?.roleName ?? 'N/A'}', // Hiển thị vai trò người dùng
              style: TextStyle(fontSize: 16),
            ),
            Spacer(), // Tạo khoảng trống để đẩy nút xuống dưới cùng
            // Nút đăng xuất
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng xuất ở đây
                // Ví dụ: Xóa dữ liệu người dùng và điều hướng đến trang đăng nhập
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu nền của nút
                iconColor: Colors.white, // Màu chữ của nút
              ),
              child: Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Xóa dữ liệu người dùng
    Navigator.pushReplacementNamed(context, '/login'); // Điều hướng đến trang đăng nhập
  }
}
