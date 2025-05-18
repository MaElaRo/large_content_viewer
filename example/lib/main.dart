import 'package:flutter/material.dart';
import 'package:large_content_viewer/large_content_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Large Content Viewer Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // Use system theme
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LCV Example'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LargeContentViewer(
              child: Text(
                'Long-press the bottom navigation items.',
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Try increasing the system font size in your device settings (Accessibility -> Display & Text Size -> Larger Text) or use the toggle above to see the Large Content Viewer activate on long-press.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// A widget that represents the bottom navigation bar for the app.
class _AppBottomNavigationBar extends StatelessWidget {
  const _AppBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
  });

  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _NavItemWidget(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            isSelected: currentIndex == 0,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _NavItemWidget(
            icon: Icons.search_outlined,
            selectedIcon: Icons.search,
            label: 'Search',
            isSelected: currentIndex == 1,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 2 ? Icons.person : Icons.person_outline),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onItemTapped,
    );
  }
}

// A widget that represents a navigation item with Large Content Viewer support.
//
// This widget wraps an icon in a LargeContentViewer to show an enlarged
// version when long-pressed.
class _NavItemWidget extends StatelessWidget {
  // Creates a navigation item widget.
  const _NavItemWidget({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
  });

  // The icon to display when not selected.
  final IconData icon;

  // The icon to display when selected.
  final IconData selectedIcon;

  // The label text for the navigation item.
  final String label;

  // Whether this navigation item is currently selected.
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LargeContentViewer(
      scaleFactor: 2.0,
      customOverlayChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSelected ? selectedIcon : icon, size: 32),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
      child: Icon(isSelected ? selectedIcon : icon),
    );
  }
}
