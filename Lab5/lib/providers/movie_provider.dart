import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../services/api_service.dart';

part 'movie_provider.g.dart';

@riverpod
ApiService apiService(ApiServiceRef ref) {
  final api = ApiService();
  ref.onDispose(() => api.dispose());
  return api;
}

@riverpod
MovieRepository movieRepository(MovieRepositoryRef ref) {
  final api = ref.watch(apiServiceProvider);
  return MovieRepository(api: api);
}

@riverpod
class MovieList extends _$MovieList {
  List<Movie> _localMovies = [];

  @override
  FutureOr<List<Movie>> build() async {
    final repo = ref.watch(movieRepositoryProvider);
    final movies = await repo.getAll();
    _localMovies = movies;
    return _localMovies;
  }

  Future<void> addMovie(Movie movie) async {
    final repo = ref.read(movieRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final newMovie = await repo.create(movie);
        _localMovies = [newMovie, ..._localMovies];
      } catch (e) {
        // Nếu API lỗi, ta vẫn giả lập add local với một ID tạm
        final tempMovie = movie.copyWith(id: DateTime.now().millisecondsSinceEpoch % 10000);
        _localMovies = [tempMovie, ..._localMovies];
      }
      return _localMovies;
    });
  }

  Future<void> updateMovie(Movie movie) async {
    final repo = ref.read(movieRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        // Chỉ gọi API nếu ID nhỏ (ID có sẵn trên server DummyJSON)
        // Nếu ID lớn (sản phẩm mới tạo), DummyJSON sẽ báo lỗi 404
        if (movie.id <= 194) {
          await repo.update(movie);
        }
      } catch (e) {
        // Bỏ qua lỗi 404 từ server DummyJSON
        print('Update API skipped or failed: $e');
      }
      
      // Luôn cập nhật local list để UI thay đổi
      _localMovies = [
        for (final m in _localMovies)
          if (m.id == movie.id) movie else m
      ];
      return _localMovies;
    });
  }

  Future<void> deleteMovie(int id) async {
    final repo = ref.read(movieRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        if (id <= 194) {
          await repo.delete(id);
        }
      } catch (e) {
        print('Delete API skipped or failed: $e');
      }
      _localMovies = _localMovies.where((m) => m.id != id).toList();
      return _localMovies;
    });
  }

  Future<void> reload() async {
    ref.invalidateSelf();
  }
}
