import 'package:flutter/material.dart';

import './categories_screen.dart';
import './favourites_screen.dart';
import '../dummy_data.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _tabs = [
    {
      'screen': const CategoriesScreen(categories: dummyCategories),
      'label': 'Categories',
    },
    {
      'screen': const FavouritesScreen(),
      'label': 'My Favourites',
    },
  ];
  var _currentIndex = 0;
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_currentIndex]['label']),
      ),
      body: _tabs[_currentIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'My Favourites',
          ),
        ],
      ),
    );
  }
}
