import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';

class MealsScreen extends StatefulWidget {
  static const routeName = 'meals';

  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late Category category;
  late List<Meal> meals;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)?.settings.arguments as Category;
    meals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
