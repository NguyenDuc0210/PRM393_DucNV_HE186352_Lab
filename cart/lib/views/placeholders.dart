import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_screen.dart';
import '../viewmodels/cart_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Home Screen")),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0, cartCount: cartState.items.length),
    );
  }
}

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Product Detail")),
      body: const Center(child: Text("Product Detail Screen")),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1, cartCount: cartState.items.length),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final int cartCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.cartCount,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 0 || index == 1) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const HomeScreen())
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const CartScreen())
          );
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home, color: Colors.black),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          activeIcon: Icon(Icons.description, color: Colors.black),
          label: 'Product Detail',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            label: Text('$cartCount'),
            backgroundColor: Colors.red,
            isLabelVisible: cartCount > 0,
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          activeIcon: Badge(
            label: Text('$cartCount'),
            backgroundColor: Colors.red,
            isLabelVisible: cartCount > 0,
            child: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
          label: 'Cart',
        ),
      ],
    );
  }
}
