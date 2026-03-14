// ============================================================
// screens/movie_detail_screen.dart
// Edit / Delete callback từ HomeScreen (không tạo repo mới)
// ============================================================

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/widgets.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.pop(context, true); // pop detail trước
              onEdit();                     // rồi mở dialog từ HomeScreen
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete',
            onPressed: () {
              Navigator.pop(context, true);
              onDelete();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: HeroBanner(posterUrl: movie.posterUrl, movieTitle: movie.title),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating + Price
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      if (movie.price > 0)
                        Text('\$${movie.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  if (movie.brand.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Brand: ${movie.brand}',
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                  const SizedBox(height: 12),
                  GenreChips(genres: movie.genres),
                  const SizedBox(height: 16),
                  Text(movie.overview,
                      style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 24),
                  ActionButtons(movie: movie),
                  const SizedBox(height: 24),
                  TrailerList(trailers: movie.trailers),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}