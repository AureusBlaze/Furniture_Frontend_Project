import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/domain/entities/category.dart';

/// Home screen category card with alternating layout.
/// Even index: image left, text right.
/// Odd index: text left, image right.
class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    this.onTap,
  });

  bool get _isReversed => index.isOdd;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.primaryDark.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: _isReversed
                ? [_buildTextSection(theme), _buildImageSection(theme)]
                : [_buildImageSection(theme), _buildTextSection(theme)],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(dynamic theme) {
    return Expanded(
      flex: 5,
      child: category.imageUrl != null && category.imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: category.imageUrl!,
              fit: BoxFit.cover,
              height: double.infinity,
              placeholder: (_, __) => Container(
                color: theme.surfaceVariant.withValues(alpha: 0.2),
              ),
              errorWidget: (_, __, ___) => _buildImagePlaceholder(theme),
            )
          : _buildImagePlaceholder(theme),
    );
  }

  Widget _buildImagePlaceholder(dynamic theme) {
    return Container(
      color: theme.surfaceVariant.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.weekend_outlined,
          size: 48,
          color: theme.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildTextSection(dynamic theme) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              _isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.name.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
                letterSpacing: 3,
                fontFamily: 'PlayfairDisplay',
              ),
              textAlign: _isReversed ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 8),
            if (category.description != null)
              Text(
                category.description!,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: _isReversed ? TextAlign.right : TextAlign.left,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment:
                  _isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (_isReversed) ...[
                  Text(
                    'EXPLORE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.accentWarm,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '←',
                    style: TextStyle(color: theme.accentWarm, fontSize: 14),
                  ),
                ] else ...[
                  Text(
                    'EXPLORE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.accentWarm,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '→',
                    style: TextStyle(color: theme.accentWarm, fontSize: 14),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
