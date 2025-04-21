import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/utils/app_theme.dart';
import 'package:flutter_ecommerce/widgets/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  int _quantity = 1;
  
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }
  
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? AppTheme.accentColor : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.borderRadiusLarge),
                  topRight: Radius.circular(AppTheme.borderRadiusLarge),
                ),
              ),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.warningColor,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating} (128 reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Categories
                  Wrap(
                    spacing: 8,
                    children: widget.product.categories.map((category) {
                      return Chip(
                        label: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        backgroundColor: AppTheme.primaryLightColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Quantity
                  Text(
                    'Quantity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onTap: _decrementQuantity,
                      ),
                      Container(
                        width: 50,
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.lightGrey),
                        ),
                        child: Center(
                          child: Text(
                            _quantity.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onTap: _incrementQuantity,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '\$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: AppTheme.spacingM),
                          child: CustomButton(
                            text: 'Add to Cart',
                            icon: Icons.shopping_cart_outlined,
                            onPressed: widget.onAddToCart,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.lightGrey),
          color: AppTheme.lightGrey,
        ),
        child: Icon(icon),
      ),
    );
  }
}