enum Affordability { affordable, pricey, luxurious }

enum Complexity { simple, hard, challenging }

class Meal {
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final List<String> categories;
  final List<String> ingredients;
  final List<String> steps;
  final Affordability affordability;
  final Complexity complexity;
  final bool isGlutenFree;
  final bool isVegan;
  final bool isVegetarian;
  final bool isLactoseFree;

  const Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.categories,
    required this.ingredients,
    required this.steps,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      categories: json['categories'],
      imageUrl: json['imageUrl'],
      duration: json['duration'],
      ingredients: json['ingredients'],
      steps: json['steps'],
      complexity: json['complexity'],
      affordability: json['affordability'],
      isGlutenFree: json['isGlutenFree'],
      isVegan: json['isVegan'],
      isVegetarian: json['isVegetarian'],
      isLactoseFree: json['isLactoseFree'],
    );
  }

  String complexityText(Complexity complexity) {
    switch (complexity) {
      case Complexity.challenging:
        return 'Challenging';
      case Complexity.hard:
        return 'Hard';
      case Complexity.simple:
        return 'Simple';
      default:
        return 'Unknown';
    }
  }

  int affordabilityCount(Affordability affordability) {
    switch (affordability) {
      case Affordability.affordable:
        return 1;
      case Affordability.pricey:
        return 2;
      case Affordability.luxurious:
        return 3;
    }
  }

  Map<String, dynamic> get toMap {
    return {
      'title': title,
      'categories': categories,
      'imageUrl': imageUrl,
      'duration': duration,
      'ingredients': ingredients,
      'steps': steps,
      'complexity': complexityText(complexity),
      'affordability': affordabilityCount(affordability),
      'isGlutenFree': isGlutenFree,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isLactoseFree': isLactoseFree
    };
  }
}
