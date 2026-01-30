// lib/exercise3/models/movie_item.dart
class MovieItem {
  final String title;
  final String description;

  MovieItem({required this.title, required this.description});

  // Dữ liệu mẫu
  static List<MovieItem> getSampleMovies() {
    return [
      MovieItem(title: 'Avatar', description: 'Sample description'),
      MovieItem(title: 'Inception', description: 'Sample description'),
      MovieItem(title: 'Interstellar', description: 'Sample description'),
      MovieItem(title: 'Joker', description: 'Sample description'),
    ];
  }
}
