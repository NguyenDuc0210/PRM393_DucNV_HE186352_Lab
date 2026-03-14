// ============================================================
// movie.dart — Dart Model cho DummyJSON /products
// fromJson: parse JSON → object | toJson: object → JSON (POST/PUT)
// ============================================================

class Trailer {
  final String title;
  final String url;

  Trailer({required this.title, required this.url});

  factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
    title: json['title'] as String? ?? 'Trailer',
    url: json['url'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'title': title, 'url': url};
}

class Movie {
  final int id;
  final String title;
  final String posterUrl;   // ← thumbnail URL từ DummyJSON
  final String overview;    // ← description
  final List<String> genres; // ← [category]
  final double rating;
  final double price;        // ← thêm price từ DummyJSON
  final String brand;        // ← thêm brand từ DummyJSON
  final List<Trailer> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    this.price = 0.0,
    this.brand = '',
    required this.trailers,
  });

  // GET — parse JSON từ API response
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'] as int? ?? 0,
    title: json['title'] as String? ?? '',
    posterUrl: json['thumbnail'] as String? ?? '',
    overview: json['description'] as String? ?? '',
    genres: [json['category'] as String? ?? 'general'],
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    brand: json['brand'] as String? ?? '',
    trailers: [
      Trailer(title: 'Official Trailer', url: ''),
    ],
  );

  // POST / PUT — convert object → JSON để gửi lên API
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': overview,
    'category': genres.isNotEmpty ? genres.first : 'general',
    'rating': rating,
    'price': price,
    'brand': brand,
    'thumbnail': posterUrl,
  };

  // copyWith — dùng cho UPDATE (chỉ thay đổi 1 số trường)
  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    List<String>? genres,
    double? rating,
    double? price,
    String? brand,
    String? posterUrl,
  }) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        posterUrl: posterUrl ?? this.posterUrl,
        overview: overview ?? this.overview,
        genres: genres ?? this.genres,
        rating: rating ?? this.rating,
        price: price ?? this.price,
        brand: brand ?? this.brand,
        trailers: trailers,
      );
}
