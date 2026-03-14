import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

// ─────────────────────────────────────────────
// MovieCard — hỗ trợ cả Image.network và Image.asset
// ─────────────────────────────────────────────
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAsset = movie.posterUrl.startsWith('images/');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isAsset
                    ? Image.asset(
                        movie.posterUrl,
                        width: 80, height: 80, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80, height: 80, color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 36),
                        ),
                      )
                    : Image.network(
                        movie.posterUrl,
                        width: 80, height: 80, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80, height: 80, color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 36),
                        ),
                        loadingBuilder: (_, child, p) => p == null
                            ? child
                            : Container(
                          width: 80, height: 80, color: Colors.grey[200],
                          child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(movie.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(movie.genres.join(', '),
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    if (movie.price > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('\$${movie.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                  ],
                ),
              ),
              // Edit icon
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                onPressed: onEditTap,
                tooltip: 'Edit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HeroBanner — hỗ trợ cả Image.network và Image.asset
// ─────────────────────────────────────────────
class HeroBanner extends StatelessWidget {
  final String posterUrl;
  final String movieTitle;

  const HeroBanner({super.key, required this.posterUrl, required this.movieTitle});

  @override
  Widget build(BuildContext context) {
    final bool isAsset = posterUrl.startsWith('images/');

    return Stack(
      fit: StackFit.expand,
      children: [
        isAsset
            ? Image.asset(
                posterUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 80)),
              )
            : Image.network(
                posterUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 80)),
              ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 16, left: 16, right: 16,
          child: Text(movieTitle,
              style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// GenreChips
// ─────────────────────────────────────────────
class GenreChips extends StatelessWidget {
  final List<String> genres;
  const GenreChips({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: genres
          .map((g) => Chip(
        label: Text(g),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
      ))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────
// ActionButtons
// ─────────────────────────────────────────────
class ActionButtons extends StatefulWidget {
  final Movie movie;
  const ActionButtons({super.key, required this.movie});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool isFavorite = false;
  bool isRated = false;
  bool _isPosting = false;
  final MovieRepository _repo = MovieRepository();

  Future<void> _toggleFavorite() async {
    if (_isPosting) return;
    setState(() => _isPosting = true);
    try {
      // Logic giả lập: Nếu nhấn favorite thì gọi create (POST) thử lên server
      if (!isFavorite) await _repo.create(widget.movie);
      setState(() => isFavorite = !isFavorite);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isFavorite ? '❤️ Added to favorites' : 'Removed from favorites'),
          duration: const Duration(seconds: 1),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
              label: 'Retry', textColor: Colors.white, onPressed: _toggleFavorite),
        ));
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  void dispose() { _repo.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sel = Colors.grey[850]!;
    final unsel = Colors.grey[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _isPosting
              ? const SizedBox(width: 28, height: 28,
              child: CircularProgressIndicator(strokeWidth: 2))
              : _btn(isFavorite ? Icons.favorite : Icons.favorite_border,
              'Favorite', isFavorite ? sel : unsel, _toggleFavorite),
          _btn(isRated ? Icons.star : Icons.star_border, 'Rate',
              isRated ? sel : unsel, () {
                setState(() => isRated = !isRated);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isRated ? 'You rated this' : 'Rating removed'),
                  duration: const Duration(seconds: 1),
                ));
              }),
          _btn(Icons.share, 'Share', unsel, () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share coming soon!')));
          }),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String label, Color color, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────
// TrailerList
// ─────────────────────────────────────────────
class TrailerList extends StatelessWidget {
  final List<Trailer> trailers;
  const TrailerList({super.key, required this.trailers});

  @override
  Widget build(BuildContext context) {
    if (trailers.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Trailers',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trailers.length,
          itemBuilder: (_, i) {
            final t = trailers[i];
            return ListTile(
              leading: const Icon(Icons.play_circle_filled, color: Colors.black, size: 32),
              title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w500)),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playing: ${t.title}'),
                      duration: const Duration(seconds: 2))),
            );
          },
        ),
      ],
    );
  }
}
