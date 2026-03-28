import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/presentation/widgets/mirage_top_bar.dart';
import 'package:mirage_by_aurues/presentation/widgets/mirage_bottom_nav_bar.dart';
import 'package:mirage_by_aurues/presentation/views/home/home_screen.dart';
import 'package:mirage_by_aurues/presentation/views/catalog/catalog_screen.dart';
import 'package:mirage_by_aurues/presentation/views/ar/ar_list_screen.dart';
import 'package:mirage_by_aurues/presentation/views/profile/profile_screen.dart';

/// App Shell — hosts TopBar + BottomNav + body via IndexedStack.
class AppShell extends StatefulWidget {
  final int initialTab;

  const AppShell({super.key, this.initialTab = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final screens = const [
      HomeScreen(),
      CatalogScreen(),
      ArListScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MirageTopBar(
        onCartTap: () => Navigator.of(context).pushNamed('/cart'),
        onSearchTap: () => Navigator.of(context).pushNamed('/search'),
        onCameraTap: () => Navigator.of(context).pushNamed('/camera'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: MirageBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
