import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'package:mirage_by_aurues/presentation/views/splash/splash_screen.dart';
import 'package:mirage_by_aurues/presentation/views/navigation/navigation_hub_screen.dart';
import 'package:mirage_by_aurues/presentation/views/shell/app_shell.dart';
import 'package:mirage_by_aurues/presentation/views/cart/cart_screen.dart';
import 'package:mirage_by_aurues/presentation/views/checkout/checkout_screen.dart';
import 'package:mirage_by_aurues/presentation/views/search/search_screen.dart';
import 'package:mirage_by_aurues/presentation/views/camera/camera_ai_screen.dart';
import 'package:mirage_by_aurues/presentation/views/profile/login_screen.dart';
import 'package:mirage_by_aurues/presentation/views/profile/register_screen.dart';
import 'package:mirage_by_aurues/presentation/views/product/product_detail_screen.dart';

class MirageApp extends StatelessWidget {
  const MirageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProvider, __) {
        return MaterialApp(
          title: 'Mirage',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          initialRoute: '/',
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case '/navigation':
        return MaterialPageRoute(
          builder: (_) => const NavigationHubScreen(),
        );
      case '/shell':
        final tabIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => AppShell(initialTab: tabIndex),
        );
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );
      case '/checkout':
        return MaterialPageRoute(
          builder: (_) => const CheckoutScreen(),
        );
      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );
      case '/camera':
        return MaterialPageRoute(
          builder: (_) => const CameraAiScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      case '/product':
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      case '/catalog':
        // Category-filtered catalog — navigates to shell with catalog tab
        return MaterialPageRoute(
          builder: (_) => AppShell(initialTab: 1),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
