import 'package:flutter/material.dart';
class ProfileAdminScreen extends StatefulWidget {
  const ProfileAdminScreen({super.key});

  @override
  _ProfileAdminScreenState createState() => _ProfileAdminScreenState();
}
class _ProfileAdminScreenState extends State<ProfileAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN-nni56QIaz-F9RYvtMXBz1ymWZo4d6gNsA&s'), // Thay thế bằng URL ảnh thực tế
            ),
            SizedBox(height: 20),
            // Thông tin cá nhân
            Text(
              'Tên người dùng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Spacer(), // Tạo khoảng trống để đẩy nút xuống dưới cùng
            // Nút đăng xuất
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng xuất ở đây
                // Ví dụ: Điều hướng đến trang đăng nhập
                Navigator.pushReplacementNamed(context, '/login');
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
}