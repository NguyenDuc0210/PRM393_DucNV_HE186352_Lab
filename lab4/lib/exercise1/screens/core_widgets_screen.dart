// lib/exercise1/screens/core_widgets_screen.dart
import 'package:flutter/material.dart';

class CoreWidgetsScreen extends StatelessWidget {
  const CoreWidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Đặt màu nền là trắng
      appBar: AppBar(
        title: const Text('Exercise 1 – Core Widgets'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        // Thêm padding cho toàn bộ body
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.movie_filter_rounded, // Icon giống trong đề
              color: Colors.blue,
              size: 100,
            ),
            const SizedBox(height: 24),
            // ClipRRect để bo góc cho ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              // Sửa lỗi: Sử dụng Image.asset để load ảnh từ thư mục local
              child: Image.asset(
                'images/810611-lqjaytrzto-1466843799.png',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              // Chỉnh sửa shape và màu sắc của Card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color(0xFFF5F5F5), // Màu xám nhạt
              child: const ListTile(
                leading: Icon(Icons.star, color: Colors.black54),
                title: Text(
                  'Movie Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('This is a sample ListTile inside a Card.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
