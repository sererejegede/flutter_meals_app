import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../providers/meals.dart';
import '../widgets/meal_item.dart';
import 'new_meal.dart';

class MealsScreen extends StatefulWidget {
  static const routeName = 'meals';

  const MealsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> _availableMeals = [];
  var _isFetching = false;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {
        _isFetching = true;
      });
      context.read<Meals>().getAllMeals().then((_) {
        setState(() {
          _isFetching = false;
        });
      });
    }
    _initialized = true;
    _availableMeals = context.watch<Meals>().meals;
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category;
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: _isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: _availableMeals
                    .where((meal) => meal.categories.contains(category.id))
                    .toList()
                    .map((meal) => MealItem(meal: meal))
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(NewMeal.routeName, arguments: category),
        child: const Icon(Icons.add),
      ),
    );
  }
}
