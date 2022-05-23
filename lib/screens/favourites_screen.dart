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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
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
                      confirmDismiss: (_) {
                        return showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text(
                                  meal.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  'Are you sure you want to remove this meal from your favourites?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(true);
                                    },
                                    child: const Text('YES'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text('NO'),
                                  )
                                ],
                              );
                            });
                      },
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
