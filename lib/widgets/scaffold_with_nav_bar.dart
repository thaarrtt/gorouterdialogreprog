import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/nav_bar_item.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.currentPath,
    required this.navBarItems,
  });

  final Widget child;
  final String currentPath;
  final List<NavBarItem> navBarItems;

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        navBarItems.indexWhere((item) => item.path == currentPath);
    final shouldShowNavBar = currentIndex >= 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: shouldShowNavBar
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => context.go(navBarItems[index].path),
              type: BottomNavigationBarType.fixed,
              items: [
                for (final item in navBarItems)
                  BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  )
              ],
            )
          : null,
    );
  }
}
