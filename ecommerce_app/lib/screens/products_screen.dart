import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_ecommerce/utils/app_theme.dart';
import 'package:flutter_ecommerce/utils/mock_data.dart';
import 'package:flutter_ecommerce/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Product> _products = MockData.products;
  final List<CartItem> _cart = [];
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Fashion', 'Audio', 'Accessories', 'Wearables', 'Bags'];
  
  void _addToCart(Product product) {
    setState(() {
      final existingIndex = _cart.indexWhere((item) => item.product.id == product.id);
      if (existingIndex >= 0) {
        _cart[existingIndex].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cart: _cart,
                    onUpdateCart: () {
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
  
  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products.where((product) => 
      product.categories.contains(_selectedCategory)).toList();
  }
  
  int get _cartItemCount {
    return _cart.fold(0, (sum, item) => sum + item.quantity);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cart: _cart,
                        onUpdateCart: () {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : AppTheme.lightGrey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () => _addToCart(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}