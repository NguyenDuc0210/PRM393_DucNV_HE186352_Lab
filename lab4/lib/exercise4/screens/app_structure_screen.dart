// lib/exercise4/screens/app_structure_screen.dart
import 'package:flutter/material.dart';

class AppStructureScreen extends StatefulWidget {
  const AppStructureScreen({super.key});

  @override
  State<AppStructureScreen> createState() => _AppStructureScreenState();
}

class _AppStructureScreenState extends State<AppStructureScreen> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Để áp dụng theme riêng, chúng ta bọc màn hình trong một MaterialApp mới.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple, brightness: Brightness.dark),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            // rootNavigator: true để đảm bảo nó thoát khỏi MaterialApp con này
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          title: const Text('Exercise 4 - App Structure'),
          actions: [
            const Text('Dark'),
            Switch(
              value: _isDarkMode,
              onChanged: _toggleTheme,
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'This is a simple screen with theme toggle.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        // Đã xóa floatingActionButton
      ),
    );
  }
}