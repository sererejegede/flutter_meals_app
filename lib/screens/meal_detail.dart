import 'package:flutter/material.dart';
import 'package:meals/screens/new_meal.dart';

import '../models/meal.dart';

class MealDetail extends StatefulWidget {
  static const routeName = 'meal-detail';
  final void Function(Meal meal) setFavourite;
  final bool Function(String mealId) isFavourite;
  const MealDetail({
    Key? key,
    required this.setFavourite,
    required this.isFavourite,
  }) : super(key: key);

  @override
  State<MealDetail> createState() => _MealDetailState();
}

class _MealDetailState extends State<MealDetail> {
  late Meal meal;

  List<Widget> listItems(List<String> items) {
    return items
        .map(
          (item) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(),
              ),
            ),
            child: Text(
              item,
              // softWrap: true,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        )
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    meal = ModalRoute.of(context)?.settings.arguments as Meal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NewMeal(
                    meal: meal,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...listItems(meal.ingredients),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'How to make ${meal.title}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...listItems(meal.steps)
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          widget.isFavourite(meal.id) ? Icons.star : Icons.star_outline,
        ),
        onPressed: () {
          widget.setFavourite(meal);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: Text('${meal.title} added to favourites'),
              action: SnackBarAction(
                label: 'Go to favourites',
                onPressed: () {
                  Navigator.of(context).pushNamed('/', arguments: 1);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
