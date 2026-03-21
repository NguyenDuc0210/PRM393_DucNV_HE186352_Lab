class CartItem {
  final int? id;
  final String name;
  final double originalPrice;
  final double discountedPrice;
  final String imageUrl;
  int quantity;

  CartItem({
    this.id,
    required this.name,
    required this.originalPrice,
    required this.discountedPrice,
    required this.imageUrl,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      originalPrice: map['originalPrice'],
      discountedPrice: map['discountedPrice'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
    );
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
