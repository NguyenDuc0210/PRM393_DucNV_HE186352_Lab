// lib/exercise3/screens/layout_demo_screen.dart
import 'package:flutter/material.dart';
import '../models/movie_item.dart';
import '../widgets/movie_list_item.dart';

class LayoutDemoScreen extends StatelessWidget {
  const LayoutDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách phim từ model
    final List<MovieItem> movies = MovieItem.getSampleMovies();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Layout Demo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Center(
              child: Text(
                'Now Playing',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Sử dụng Expanded và ListView.builder để hiển thị danh sách
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                // Sử dụng widget con đã được tách ra
                return MovieListItem(movie: movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}