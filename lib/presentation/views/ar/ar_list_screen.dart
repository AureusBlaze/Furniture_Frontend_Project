import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/ar_list_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/shimmer_loading.dart';

/// AR List screen — products with AR support.
class ArListScreen extends StatefulWidget {
  const ArListScreen({super.key});

  @override
  State<ArListScreen> createState() => _ArListScreenState();
}

class _ArListScreenState extends State<ArListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArListViewModel>().loadArProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Container(
      color: theme.surface,
      child: Consumer<ArListViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const ShimmerProductGrid();
          }

          if (vm.error != null && vm.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.view_in_ar, size: 48, color: theme.textSecondary),
                  const SizedBox(height: 16),
                  Text('Unable to load AR products',
                      style: MirageTypography.headingMedium(color: theme.textPrimary)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: vm.loadArProducts,
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            );
          }

          if (vm.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.view_in_ar_outlined, size: 64,
                      color: theme.textSecondary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No AR products available',
                      style: MirageTypography.headingMedium(color: theme.textPrimary)),
                  const SizedBox(height: 8),
                  Text('AR-enabled products will appear here',
                      style: MirageTypography.bodyMedium(color: theme.textSecondary)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              bottom: 100,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: vm.products.length,
            itemBuilder: (_, index) {
              final product = vm.products[index];
              return ProductCard(
                product: product,
                onTap: () => Navigator.of(context).pushNamed(
                  '/product',
                  arguments: product.id,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
