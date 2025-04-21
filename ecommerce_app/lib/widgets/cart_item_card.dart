import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/utils/app_theme.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onUpdateQuantity;
  final VoidCallback onRemove;
  
  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: AppTheme.lightShadow,
      ),
      child: Dismissible(
        key: Key(cartItem.product.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppTheme.spacingL),
          decoration: BoxDecoration(
            color: AppTheme.errorColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) => onRemove(),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                child: Image.network(
                  cartItem.product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${cartItem.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Quantity Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (cartItem.quantity > 1) {
                                  onUpdateQuantity(cartItem.quantity - 1);
                                }
                              },
                            ),
                            Container(
                              width: 35,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.lightGrey),
                              ),
                              child: Center(
                                child: Text(
                                  cartItem.quantity.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onTap: () {
                                onUpdateQuantity(cartItem.quantity + 1);
                              },
                            ),
                          ],
                        ),
                        Text(
                          '\$${cartItem.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.lightGrey),
          color: AppTheme.lightGrey,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}