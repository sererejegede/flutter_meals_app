import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavouritesScreen extends StatelessWidget {
  static const routeName = 'favourites';
  final List<Meal> meals;
  final void Function(String mealId) removeFromFavourite;
  final void Function(Meal meal) setFavourite;

  const FavouritesScreen({
    Key? key,
    required this.meals,
    required this.removeFromFavourite,
    required this.setFavourite,
  }) : super(key: key);

  void _onRemoveFavourite(Meal meal, BuildContext context) {
    removeFromFavourite(meal.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          'Removed ${meal.title} from favourites!',
        ),
        // action: SnackBarAction(
        //   label: 'UNDO',
        //   onPressed: () => setFavourite(meal),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: meals.isNotEmpty
          ? ListView(
              children: meals
                  .map(
                    (meal) => Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(meal.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Icon(
                          Icons.delete,
                          size: 48,
                        ),
                      ),
                      onDismissed: (_) => _onRemoveFavourite(meal, context),
                      child: MealItem(
                        meal: meal,
                      ),
                    ),
                  )
                  .toList(),
            )
          : const Center(
              child: Text('No favourites added yet'),
            ),
    );
  }
}
