import 'package:flutter/material.dart';

import './categories_screen.dart';
import './favourites_screen.dart';
import '../components/main_drawer.dart';
import '../components/modal.dart';
import '../models/meal.dart';
import '../widgets/new_category.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favouriteMeals;
  final void Function(String mealId) removeFromFavourite;
  final void Function(Meal meal) setFavourite;

  const TabsScreen({
    Key? key,
    required this.favouriteMeals,
    required this.removeFromFavourite,
    required this.setFavourite,
  }) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, dynamic>> _tabs;
  var _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const Modal(child: NewCategory()),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      {
        'screen': const CategoriesScreen(),
        'label': 'Categories',
      },
      {
        'screen': FavouritesScreen(
          meals: widget.favouriteMeals,
          setFavourite: widget.setFavourite,
          removeFromFavourite: widget.removeFromFavourite,
        ),
        'label': 'My Favourites',
      },
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _initialIndex = ModalRoute.of(context)?.settings.arguments;
    if (_initialIndex != null && _initialIndex is int) {
      _currentIndex = _initialIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_currentIndex]['label']),
      ),
      drawer: const MainDrawer(),
      body: _tabs[_currentIndex]['screen'],
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.star),
            icon: Icon(Icons.star_border),
            label: 'My Favourites',
          ),
        ],
      ),
    );
  }
}
