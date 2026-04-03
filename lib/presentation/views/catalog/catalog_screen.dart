import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/catalog_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/shimmer_loading.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';

/// Catalog screen — 2-column product grid with pagination on background.
/// Each product card is wrapped in RepaintBoundary for scroll perf.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogViewModel>().loadProducts();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CatalogViewModel>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return BackgroundLayer(
      child: Consumer<CatalogViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const ShimmerProductGrid();
          }

          if (vm.error != null && vm.products.isEmpty) {
            return _buildError(vm, theme);
          }

          return RefreshIndicator(
            onRefresh: vm.refresh,
            color: theme.accent,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 80,
                    left: 16,
                    right: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'FULL CATALOG',
                              style: MirageTypography.displaySmall(
                                color: theme.textOnDark,
                              ).copyWith(letterSpacing: 4),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.tune,
                                  size: 18,
                                  color: theme.textOnDark
                                      .withValues(alpha: 0.6)),
                              label: Text(
                                'FILTERS',
                                style: MirageTypography.labelSmall(
                                  color: theme.textOnDark
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) {
                        final product = vm.products[index];
                        // RepaintBoundary isolates each card's blur
                        return RepaintBoundary(
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/product',
                                arguments: product.id,
                              );
                            },
                          ),
                        );
                      },
                      childCount: vm.products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                  ),
                ),
                if (vm.isLoadingMore)
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.accent,
                        ),
                      ),
                    ),
                  ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 100),
                  sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(CatalogViewModel vm, dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off,
                size: 48,
                color: theme.textOnDark.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('Unable to load products',
                style: MirageTypography.headingMedium(
                    color: theme.textOnDark)),
            const SizedBox(height: 8),
            Text(vm.error!,
                style: MirageTypography.bodySmall(
                    color: theme.textOnDark.withValues(alpha: 0.5))),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: vm.refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentWarm,
                foregroundColor: theme.textOnDark,
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
