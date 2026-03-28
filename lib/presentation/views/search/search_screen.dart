import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/search_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';

/// Full-screen search overlay.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: TextStyle(color: theme.textPrimary, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search furniture...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(color: theme.textSecondary),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (query) {
                        context.read<SearchViewModel>().search(query);
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close, color: theme.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchViewModel>().clear();
                      },
                    ),
                ],
              ),
            ),
            Divider(height: 1, color: theme.surfaceVariant.withValues(alpha: 0.3)),
            // Results
            Expanded(
              child: Consumer<SearchViewModel>(
                builder: (_, vm, __) {
                  if (vm.query.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 64,
                              color: theme.textSecondary.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          Text(
                            'Search for furniture',
                            style: MirageTypography.bodyMedium(
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (vm.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.accent,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (vm.results.isEmpty) {
                    return Center(
                      child: Text(
                        'No results for "${vm.query}"',
                        style: MirageTypography.bodyMedium(
                          color: theme.textSecondary,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: vm.results.length,
                    itemBuilder: (_, index) {
                      final product = vm.results[index];
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
            ),
          ],
        ),
      ),
    );
  }
}
