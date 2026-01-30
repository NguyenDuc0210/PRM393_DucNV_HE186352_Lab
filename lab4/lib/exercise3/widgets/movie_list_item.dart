// lib/exercise3/widgets/movie_list_item.dart
import 'package:flutter/material.dart';
import '../models/movie_item.dart';

class MovieListItem extends StatelessWidget {
  final MovieItem movie;

  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(movie.title.isNotEmpty ? movie.title[0] : '?'),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.description),
        tileColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
