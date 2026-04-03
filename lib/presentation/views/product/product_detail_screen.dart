import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/product_detail_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';

/// Product detail screen — hero image, info, and add to cart.
class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailViewModel>().loadProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: Consumer<ProductDetailViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.accent, strokeWidth: 2),
            );
          }

          if (vm.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error loading product',
                      style: MirageTypography.headingMedium(color: theme.textPrimary)),
                  const SizedBox(height: 8),
                  Text(vm.error!, style: TextStyle(color: theme.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadProduct(widget.productId),
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            );
          }

          final product = vm.product;
          if (product == null) return const SizedBox.shrink();

          return CustomScrollView(
            slivers: [
              // Hero image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: theme.surface,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.surface.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.textPrimary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  if (product.hasArModel)
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.accent.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.view_in_ar, size: 16, color: theme.primaryDark),
                          const SizedBox(width: 4),
                          Text('AR', style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: theme.primaryDark,
                          )),
                        ],
                      ),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: product.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: product.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: theme.surfaceVariant.withValues(alpha: 0.2),
                            child: Icon(Icons.image, size: 64, color: theme.textSecondary),
                          ),
                        )
                      : Container(
                          color: theme.surfaceVariant.withValues(alpha: 0.2),
                          child: Icon(Icons.image, size: 64, color: theme.textSecondary),
                        ),
                ),
              ),
              // Product info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.categoryName != null)
                        Text(
                          product.categoryName!.toUpperCase(),
                          style: MirageTypography.labelSmall(color: theme.textSecondary)
                              .copyWith(letterSpacing: 3),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        style: MirageTypography.displaySmall(
                          color: theme.textPrimary,
                        ).copyWith(letterSpacing: 1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: MirageTypography.price(
                          color: theme.textPrimary,
                        ).copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        product.description,
                        style: MirageTypography.bodyLarge(
                          color: theme.textSecondary,
                        ).copyWith(height: 1.8),
                      ),
                      const SizedBox(height: 32),
                      // Quantity selector
                      Row(
                        children: [
                          Text('Quantity',
                              style: MirageTypography.headingSmall(
                                  color: theme.textPrimary)),
                          const Spacer(),
                          _quantityButton(Icons.remove, theme,
                              () => vm.decrementQuantity()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '${vm.quantity}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: theme.textPrimary,
                              ),
                            ),
                          ),
                          _quantityButton(Icons.add, theme,
                              () => vm.incrementQuantity()),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Add to cart — isolated in its own Consumer + RepaintBoundary
                      // so CartViewModel rebuilds touch ONLY this button, not the
                      // entire product detail CustomScrollView.
                      RepaintBoundary(
                        child: Selector<CartViewModel, bool>(
                          selector: (_, vm) => vm.isBusy,
                          builder: (_, isBusy, __) {
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: isBusy
                                    ? null
                                    : () async {
                                        final cartVm = context.read<CartViewModel>();
                                        final messenger = ScaffoldMessenger.of(context);
                                        final productName = product.name;

                                        try {
                                          final success = await cartVm.addToCart(
                                            CartItem(
                                              productId: product.id,
                                              name: productName,
                                              price: product.price,
                                              imageUrl: product.imageUrl,
                                              quantity: vm.quantity,
                                            ),
                                          );

                                          if (!context.mounted) return;

                                          messenger.clearSnackBars();
                                          messenger.showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                success
                                                    ? '$productName added to cart'
                                                    : 'Could not add to cart — please try again',
                                              ),
                                              backgroundColor: success
                                                  ? theme.primaryDark
                                                  : theme.error,
                                              behavior: SnackBarBehavior.floating,
                                              duration: const Duration(seconds: 2),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          debugPrint('[ProductDetail] ❌ Add to cart error: $e');
                                          if (!context.mounted) return;
                                          messenger.clearSnackBars();
                                          messenger.showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e'),
                                              backgroundColor: theme.error,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                icon: isBusy
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.textOnDark,
                                        ),
                                      )
                                    : const Icon(Icons.shopping_bag_outlined),
                                label: Text(isBusy ? 'ADDING...' : 'ADD TO CART'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _quantityButton(IconData icon, dynamic theme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: theme.surfaceVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: theme.textPrimary),
      ),
    );
  }
}
