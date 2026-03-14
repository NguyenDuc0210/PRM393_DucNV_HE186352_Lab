import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/widgets.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _reload() {
    ref.read(movieListProvider.notifier).reload();
  }

  Future<void> _showAddDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (_) => const _MovieFormDialog(),
    );
  }

  Future<void> _showEditDialog(Movie movie) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => _MovieFormDialog(movie: movie),
    );
  }

  Future<void> _deleteMovie(Movie movie) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete'),
        content: Text('Delete "${movie.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await ref.read(movieListProvider.notifier).deleteMovie(movie.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${movie.title}" deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add product',
        child: const Icon(Icons.add),
      ),
      body: movieState.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Dismissible(
                key: Key('movie_${movie.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _deleteMovie(movie);
                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 28),
                ),
                child: MovieCard(
                  movie: movie,
                  onEditTap: () => _showEditDialog(movie),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(
                          movie: movie,
                          onEdit: () => _showEditDialog(movie),
                          onDelete: () => _deleteMovie(movie),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text('$err', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieFormDialog extends ConsumerStatefulWidget {
  final Movie? movie;

  const _MovieFormDialog({this.movie});

  @override
  ConsumerState<_MovieFormDialog> createState() => _MovieFormDialogState();
}

class _MovieFormDialogState extends ConsumerState<_MovieFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _ratingCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _imageCtrl;
  bool _isLoading = false;

  bool get _isEdit => widget.movie != null;

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _titleCtrl = TextEditingController(text: m?.title ?? '');
    _descCtrl = TextEditingController(text: m?.overview ?? '');
    _categoryCtrl = TextEditingController(text: m?.genres.firstOrNull ?? '');
    _brandCtrl = TextEditingController(text: m?.brand ?? '');
    _ratingCtrl = TextEditingController(text: m != null ? m.rating.toStringAsFixed(1) : '');
    _priceCtrl = TextEditingController(text: m != null ? m.price.toStringAsFixed(2) : '');
    _imageCtrl = TextEditingController(text: m?.posterUrl ?? '');
  }

  @override
  void dispose() {
    for (final c in [_titleCtrl, _descCtrl, _categoryCtrl, _brandCtrl, _ratingCtrl, _priceCtrl, _imageCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final movie = Movie(
      id: widget.movie?.id ?? 0,
      title: _titleCtrl.text.trim(),
      overview: _descCtrl.text.trim(),
      genres: [_categoryCtrl.text.trim()],
      brand: _brandCtrl.text.trim(),
      rating: double.tryParse(_ratingCtrl.text) ?? 0.0,
      price: double.tryParse(_priceCtrl.text) ?? 0.0,
      posterUrl: _imageCtrl.text.trim().isNotEmpty 
          ? _imageCtrl.text.trim() 
          : 'https://dummyjson.com/image/i/products/${widget.movie?.id ?? 1}/thumbnail.jpg',
      trailers: widget.movie?.trailers ?? [],
    );

    try {
      if (_isEdit) {
        await ref.read(movieListProvider.notifier).updateMovie(movie);
      } else {
        await ref.read(movieListProvider.notifier).addMovie(movie);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Product' : 'Add Product'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(_titleCtrl, 'Title', required: true),
            _field(_descCtrl, 'Description', maxLines: 2),
            _field(_imageCtrl, 'Image URL'),
            _field(_categoryCtrl, 'Category'),
            _field(_brandCtrl, 'Brand'),
            _field(_ratingCtrl, 'Rating (0–5)', keyboard: TextInputType.number, validator: (v) {
              final n = double.tryParse(v ?? '');
              return (n == null || n < 0 || n > 5) ? 'Enter 0.0 – 5.0' : null;
            }),
            _field(_priceCtrl, 'Price', keyboard: TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isEdit ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
        validator: validator ?? (required ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null : null),
      ),
    );
  }
}
