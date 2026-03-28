
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/camera_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/glassmorphic_container.dart';

/// Camera AI screen — capture a room photo and get furniture suggestions.
class CameraAiScreen extends StatelessWidget {
  const CameraAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      backgroundColor: theme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textOnDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'AI ROOM ANALYSIS',
          style: MirageTypography.labelLarge(color: theme.textOnDark)
              .copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: Consumer<CameraViewModel>(
        builder: (_, vm, __) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Image preview or capture prompt
                _buildImageSection(context, vm, theme),
                const SizedBox(height: 20),
                // Action buttons
                if (vm.capturedImage != null && !vm.isAnalyzing)
                  _buildActionButtons(vm, theme),
                // Loading
                if (vm.isAnalyzing) _buildLoading(theme),
                // Error
                if (vm.error != null) _buildError(vm, theme),
                // Suggestions
                if (vm.suggestions.isNotEmpty)
                  _buildSuggestions(context, vm, theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(
      BuildContext context, CameraViewModel vm, dynamic theme) {
    if (vm.capturedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          vm.capturedImage!,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showCaptureOptions(context, vm),
      child: GlassmorphicContainer(
        height: 300,
        borderRadius: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 64,
                color: theme.textOnDark.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'CAPTURE YOUR ROOM',
              style: MirageTypography.labelLarge(color: theme.textOnDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo of your room and our AI\nwill suggest matching furniture',
              textAlign: TextAlign.center,
              style: MirageTypography.bodySmall(
                color: theme.textOnDark.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCaptureOptions(BuildContext context, CameraViewModel vm) {
    final theme = context.read<ThemeProvider>().currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.primaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: theme.accent),
              title: Text('Camera', style: TextStyle(color: theme.textOnDark)),
              onTap: () {
                Navigator.pop(context);
                vm.captureFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: theme.accent),
              title: Text('Gallery', style: TextStyle(color: theme.textOnDark)),
              onTap: () {
                Navigator.pop(context);
                vm.pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(CameraViewModel vm, dynamic theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: vm.reset,
            icon: Icon(Icons.refresh, color: theme.textOnDark),
            label: Text('RETAKE', style: TextStyle(color: theme.textOnDark)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.textOnDark.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: vm.analyzeRoom,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('ANALYZE ROOM'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accent,
              foregroundColor: theme.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          CircularProgressIndicator(color: theme.accent, strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            'Analyzing your room...',
            style: MirageTypography.bodyMedium(color: theme.textOnDark),
          ),
        ],
      ),
    );
  }

  Widget _buildError(CameraViewModel vm, dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GlassmorphicContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                vm.error!,
                style: TextStyle(color: theme.error, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(
      BuildContext context, CameraViewModel vm, dynamic theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'SUGGESTED FURNITURE',
          style: MirageTypography.labelLarge(color: theme.textOnDark)
              .copyWith(letterSpacing: 3),
        ),
        const SizedBox(height: 4),
        Text(
          '${vm.suggestions.length} items match your room',
          style: MirageTypography.bodySmall(
            color: theme.textOnDark.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: vm.suggestions.length,
          itemBuilder: (_, index) {
            final product = vm.suggestions[index];
            return ProductCard(
              product: product,
              onTap: () => Navigator.of(context).pushNamed(
                '/product',
                arguments: product.id,
              ),
            );
          },
        ),
      ],
    );
  }
}
