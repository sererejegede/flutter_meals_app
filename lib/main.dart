import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './dummy_data.dart';
import './models/meal.dart';
import './providers/categories.dart';
import './providers/meals.dart';
import './screens/filters_screen.dart';
import './screens/meal_detail.dart';
import './screens/meals_screen.dart';
import './screens/new_meal.dart';
import './screens/tabs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Meal> _availableMeals = dummyMeals;
  final List<Meal> _favoriteMeals = [];
  var _filters = {
    'isGlutenFree': true,
    'isLactoseFree': true,
    'isVegan': true,
    'isVegetarian': false
  };

  void _saveFilters(Map<String, bool> filters) {
    setState(() {
      _filters = filters;

      _availableMeals = dummyMeals.where((meal) {
        if (filters['isGlutenFree']! && !meal.isGlutenFree) return false;
        if (filters['isLactoseFree']! && !meal.isLactoseFree) return false;
        if (filters['isVegan']! && !meal.isVegan) return false;
        if (filters['isVegetarian']! && !meal.isVegetarian) return false;
        return true;
      }).toList();
    });
  }

  void _setFavourite(Meal meal) {
    setState(() {
      _favoriteMeals.add(meal);
    });
  }

  void _removeFromFavourite(String mealId) {
    setState(() {
      _favoriteMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  bool _isFavourite(String mealId) {
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Categories(),
        ),
        ChangeNotifierProvider(
          create: (_) => Meals(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'RobotoCondensed',
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
        ),
        routes: {
          '/': (_) => TabsScreen(
                favouriteMeals: _favoriteMeals,
                removeFromFavourite: _removeFromFavourite,
                setFavourite: _setFavourite,
              ),
          MealsScreen.routeName: (_) => MealsScreen(
                availableMeals: _availableMeals,
              ),
          NewMeal.routeName: (_) => const NewMeal(),
          MealDetail.routeName: (_) => MealDetail(
                setFavourite: _setFavourite,
                isFavourite: _isFavourite,
              ),
          FiltersScreen.routeName: (_) => FiltersScreen(
                currentFilters: _filters,
                saveFilters: _saveFilters,
              ),
        },
      ),
    );
  }
}
