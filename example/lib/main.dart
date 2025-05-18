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

  Widget _buildNavItem(
      {required IconData icon,
      required IconData selectedIcon,
      required String label,
      required int index,
      required bool isSelected,
      required VoidCallback onLongPressEnd}) {
    final iconWidget = Icon(isSelected ? selectedIcon : icon);
    final labelWidget = Text(label);

    return LargeContentViewer(
      scaleFactor: 2.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [iconWidget],
      ),
    );
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
            Text(
              'Long-press the bottom navigation items.',
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
      bottomNavigationBar: BottomNavigationBar(
        // Use showUnselectedLabels/showSelectedLabels for consistent layout
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
                index: 0,
                isSelected: _selectedIndex == 0,
                onLongPressEnd: () {}),
            label:
                'Home', // Label required but visually provided by _buildNavItem
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
                icon: Icons.search_outlined,
                selectedIcon: Icons.search,
                label: 'Search',
                index: 1,
                isSelected: _selectedIndex == 1,
                onLongPressEnd: () {}),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
                index: 2,
                isSelected: _selectedIndex == 2,
                onLongPressEnd: () {}),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
