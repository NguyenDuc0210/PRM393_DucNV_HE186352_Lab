import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../data/database_helper.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;

  CartState({this.items = const [], this.isLoading = false});

  double get subtotal => items.fold(0, (sum, item) => sum + (item.discountedPrice * item.quantity));

  double get totalDiscount => items.isEmpty ? 0 : 400.0;

  double get total => (subtotal - totalDiscount) < 0 ? 0 : (subtotal - totalDiscount);

  CartState copyWith({List<CartItem>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true);
    final items = await DatabaseHelper.instance.getAllItems();
    state = state.copyWith(items: items, isLoading: false);
  }

  Future<void> updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity <= 0) return;
    final updatedItem = item.copyWith(quantity: newQuantity);
    await DatabaseHelper.instance.update(updatedItem);
    await loadCart();
  }

  Future<void> removeItem(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadCart();
  }
}

final cartProvider = StateNotifierProvider<CartViewModel, CartState>((ref) {
  return CartViewModel();
});
