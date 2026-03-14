// ============================================================
// repositories/movie_repository.dart  — Data Access Layer
// Chứa toàn bộ CRUD logic, map JSON ↔ Model
// UI chỉ gọi Repository, không gọi ApiService trực tiếp
//
// Kiến trúc:
//   UI (Screen)
//     ↓ gọi
//   Repository  ← bạn đang ở đây
//     ↓ gọi
//   ApiService  (HTTP thuần)
// ============================================================

import '../models/movie.dart';
import '../services/api_service.dart';

class MovieRepository {
  final ApiService _api;

  MovieRepository({ApiService? api}) : _api = api ?? ApiService();

  // ─────────────────────────────────────────────
  // READ — GET /products?limit=20
  // ─────────────────────────────────────────────
  Future<List<Movie>> getAll() async {
    final data = await _api.get('/products?limit=20');
    final list = data['products'] as List<dynamic>;
    return list.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ─────────────────────────────────────────────
  // READ — GET /products/:id
  // ─────────────────────────────────────────────
  Future<Movie> getById(int id) async {
    final data = await _api.get('/products/$id');
    return Movie.fromJson(data);
  }

  // ─────────────────────────────────────────────
  // READ — GET /products/search?q=keyword
  // ─────────────────────────────────────────────
  Future<List<Movie>> search(String query) async {
    final data = await _api.get('/products/search?q=${Uri.encodeComponent(query)}');
    final list = data['products'] as List<dynamic>;
    return list.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ─────────────────────────────────────────────
  // CREATE — POST /products/add
  // ─────────────────────────────────────────────
  Future<Movie> create(Movie movie) async {
    final data = await _api.post('/products/add', movie.toJson());
    return Movie.fromJson(data);
  }

  // ─────────────────────────────────────────────
  // UPDATE — PUT /products/:id  (toàn bộ object)
  // ─────────────────────────────────────────────
  Future<Movie> update(Movie movie) async {
    final data = await _api.put('/products/${movie.id}', movie.toJson());
    return Movie.fromJson(data);
  }

  // ─────────────────────────────────────────────
  // UPDATE — PATCH /products/:id  (1 phần)
  // ─────────────────────────────────────────────
  Future<Movie> patch(int id, Map<String, dynamic> fields) async {
    final data = await _api.patch('/products/$id', fields);
    return Movie.fromJson(data);
  }

  // ─────────────────────────────────────────────
  // DELETE — DELETE /products/:id
  // ─────────────────────────────────────────────
  Future<bool> delete(int id) async {
    final data = await _api.delete('/products/$id');
    return data['isDeleted'] as bool? ?? false;
  }

  void dispose() => _api.dispose();
}