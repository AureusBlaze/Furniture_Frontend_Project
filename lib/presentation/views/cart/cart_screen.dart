import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';

/// Cart screen — list of items with quantity controls.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'YOUR CART',
          style: MirageTypography.labelLarge(color: theme.textPrimary)
              .copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartViewModel>(
        builder: (_, vm, __) {
          if (vm.items.isEmpty) {
            return _buildEmptyCart(theme);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.items.length,
                  itemBuilder: (_, index) {
                    return _buildCartItem(context, vm, vm.items[index], theme);
                  },
                ),
              ),
              _buildBottomTotal(context, vm, theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(dynamic theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64,
              color: theme.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: MirageTypography.headingMedium(color: theme.textPrimary)),
          const SizedBox(height: 8),
          Text('Add items to get started',
              style: MirageTypography.bodyMedium(color: theme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context, CartViewModel vm, CartItem item, dynamic theme) {
    return Dismissible(
      key: Key('cart_${item.productId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: theme.error),
      ),
      onDismissed: (_) => vm.removeItem(item.productId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.primaryDark.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.surfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(item.imageUrl!, fit: BoxFit.cover),
                    )
                  : Icon(Icons.image_outlined, color: theme.textSecondary),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.accentWarm,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity
            Column(
              children: [
                _quantityButton(
                  icon: Icons.add,
                  theme: theme,
                  onTap: () => vm.updateQuantity(item.productId, item.quantity + 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${item.quantity}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                _quantityButton(
                  icon: Icons.remove,
                  theme: theme,
                  onTap: () {
                    if (item.quantity > 1) {
                      vm.updateQuantity(item.productId, item.quantity - 1);
                    } else {
                      vm.removeItem(item.productId);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required dynamic theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: theme.surfaceVariant, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: theme.textPrimary),
      ),
    );
  }

  Widget _buildBottomTotal(BuildContext context, CartViewModel vm, dynamic theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.primaryDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: MirageTypography.headingMedium(color: theme.textPrimary)),
                Text(
                  '\$${vm.totalAmount.toStringAsFixed(2)}',
                  style: MirageTypography.price(color: theme.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/checkout');
                },
                child: const Text('PROCEED TO CHECKOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
