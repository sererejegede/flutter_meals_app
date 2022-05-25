import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'new_meal.dart';

class MealsScreen extends StatelessWidget {
  static const routeName = 'meals';
  final List<Meal> availableMeals;

  const MealsScreen({
    Key? key,
    required this.availableMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category;
    final meals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: meals.map((meal) => MealItem(meal: meal)).toList(),
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
