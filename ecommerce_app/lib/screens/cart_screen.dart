import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/screens/checkout_screen.dart';
import 'package:flutter_ecommerce/utils/app_theme.dart';
import 'package:flutter_ecommerce/widgets/cart_item_card.dart';
import 'package:flutter_ecommerce/widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final VoidCallback onUpdateCart;
  
  const CartScreen({
    super.key,
    required this.cart,
    required this.onUpdateCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _updateQuantity(int index, int quantity) {
    setState(() {
      widget.cart[index].quantity = quantity;
      widget.onUpdateCart();
    });
  }
  
  void _removeItem(int index) {
    setState(() {
      widget.cart.removeAt(index);
      widget.onUpdateCart();
    });
  }
  
  double get _subtotal {
    return widget.cart.fold(0, (sum, item) => sum + item.total);
  }
  
  double get _tax {
    return _subtotal * 0.08;
  }
  
  double get _shipping {
    return _subtotal > 100 ? 0 : 10;
  }
  
  double get _total {
    return _subtotal + _tax + _shipping;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: widget.cart.isEmpty
          ? _buildEmptyCart()
          : _buildCartContent(),
    );
  }
  
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Look like you haven\'t added anything to your cart yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingL),
          CustomButton(
            text: 'Continue Shopping',
            isFullWidth: false,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            itemCount: widget.cart.length,
            itemBuilder: (context, index) {
              final cartItem = widget.cart[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: CartItemCard(
                  cartItem: cartItem,
                  onUpdateQuantity: (quantity) => _updateQuantity(index, quantity),
                  onRemove: () => _removeItem(index),
                ),
              );
            },
          ),
        ),
        _buildCartSummary(),
      ],
    );
  }
  
  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.borderRadiusLarge),
          topRight: Radius.circular(AppTheme.borderRadiusLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax (8%)', '\$${_tax.toStringAsFixed(2)}'),
          _buildSummaryRow(
            'Shipping', 
            _shipping > 0 
                ? '\$${_shipping.toStringAsFixed(2)}' 
                : 'Free',
            _shipping > 0 ? null : AppTheme.successColor,
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total', 
            '\$${_total.toStringAsFixed(2)}',
            AppTheme.primaryColor,
            true,
          ),
          const SizedBox(height: AppTheme.spacingL),
          CustomButton(
            text: 'Proceed to Checkout',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    cart: widget.cart,
                    subtotal: _subtotal,
                    tax: _tax,
                    shipping: _shipping,
                    total: _total,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, [Color? valueColor, bool isLarge = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isLarge
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
          ),
          Text(
            value,
            style: isLarge
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  )
                : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
          ),
        ],
      ),
    );
  }
}