import 'package:flutter/material.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/categories.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../components/multi_input.dart';
import '../components/multi_select.dart';
import '../providers/meals.dart';

enum FoodOption { glutenFree, vegan, vegetarian, lactoseFree }

class NewMeal extends StatefulWidget {
  static const routeName = 'new_meal';
  final Meal? meal;
  const NewMeal({Key? key, this.meal}) : super(key: key);

  @override
  State<NewMeal> createState() => _NewMealState();
}

class _NewMealState extends State<NewMeal> {
  final _formKey = GlobalKey<FormState>();

  List<Category> _selectedCategories = [];
  late List<Category> _allCategories;
  late String _title;
  late String _duration;
  late String _imageUrl;
  late Affordability _affordability;
  late Complexity _complexity;
  late List<String> _steps;
  late List<String> _ingredients;
  var _isGlutenFree = false;
  var _isVegan = false;
  var _isVegetarian = false;
  var _isLactoseFree = false;

  var _submitting = false;

  String _complexityText(Complexity complexity) {
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

  String _affordabilityText(Affordability affordability) {
    switch (affordability) {
      case Affordability.affordable:
        return '\$ Affordable';
      case Affordability.pricey:
        return '\$\$ Pricey';
      case Affordability.luxurious:
        return '\$\$\$ Luxurious';
    }
  }

  void onSubmit() async {
    try {
      if (_submitting) return;
      setState(() {
        _submitting = true;
      });
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
      }
      var meal = {
        'title': _title,
        'categories':
            _selectedCategories.map((category) => category.id).toList(),
        'imageUrl': _imageUrl,
        'duration': _duration,
        'ingredients': _ingredients,
        'steps': _steps,
        'complexity': _complexityText(_complexity),
        'affordability': _affordabilityText(_affordability),
        'isGlutenFree': _isGlutenFree,
        'isVegan': _isVegan,
        'isVegetarian': _isVegetarian,
        'isLactoseFree': _isLactoseFree
      };
      await context.read<Meals>().addMeal(meal);
      setState(() {
        _submitting = false;
      });
    } catch (e) {
      _submitting = false;
      rethrow;
    }
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isGlutenFree = widget.meal?.isGlutenFree ?? false;
    _isLactoseFree = widget.meal?.isLactoseFree ?? false;
    _isVegan = widget.meal?.isVegan ?? false;
    _isVegetarian = widget.meal?.isVegetarian ?? false;
    _allCategories = context.read<Categories>().categories;
    _selectedCategories = _allCategories
        .where((category) =>
            widget.meal?.categories.contains(category.id) ?? false)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.meal != null
                                ? 'Edit meal'
                                : 'Add a new meal',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    initialValue: widget.meal?.title,
                    onSaved: (val) {
                      _title = val!;
                    },
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MultiSelectFormField<Category>(
                    labelText: 'Choose categories',
                    options: context.read<Categories>().categories,
                    titleBuilder: (category) => Text(
                      category.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    selectedValues: _selectedCategories,
                    onSaved: (val) {
                      setState(() {
                        _selectedCategories = val ?? [];
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Affordability>(
                          value: widget.meal?.affordability,
                          menuMaxHeight: 500,
                          decoration: const InputDecoration(
                            labelText: 'Affordability',
                          ),
                          items: Affordability.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    _affordabilityText(value),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            _affordability = val!;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<Complexity>(
                          value: widget.meal?.complexity,
                          menuMaxHeight: 500,
                          decoration: const InputDecoration(
                            labelText: 'Complexity',
                          ),
                          items: Complexity.values
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    _complexityText(value),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            _complexity = val!;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: widget.meal?.imageUrl,
                    onSaved: (val) {
                      _imageUrl = val!;
                    },
                    validator: (val) {
                      if (val == null || val == '') {
                        return 'Please fill this field';
                      }
                      if (!val.startsWith(RegExp(r'https://'))) {
                        return 'URL should start with https://';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: widget.meal?.duration.toString(),
                    onSaved: (val) {
                      _duration = val!;
                    },
                    // TODO: add 'mins' as a suffix icon
                    decoration: const InputDecoration(labelText: 'Duration'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MultiInputFormField(
                    labelText: 'Steps',
                    context: context,
                    initialValues: widget.meal?.steps,
                    onSaved: (val) {
                      if (val != null) {
                        _steps = val;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MultiInputFormField(
                    labelText: 'Ingredients',
                    context: context,
                    initialValues: widget.meal?.ingredients,
                    onSaved: (val) {
                      if (val != null) {
                        _ingredients = val;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    shrinkWrap: true,
                    children: [
                      buildCheckbox(
                        'Gluten free?',
                        FoodOption.glutenFree,
                        _isGlutenFree,
                      ),
                      buildCheckbox(
                        'Lactose free?',
                        FoodOption.lactoseFree,
                        _isLactoseFree,
                      ),
                      buildCheckbox(
                        'Vegan',
                        FoodOption.vegan,
                        _isVegan,
                      ),
                      buildCheckbox(
                        'Vegetarian',
                        FoodOption.vegetarian,
                        _isVegetarian,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Button(
                    loading: _submitting,
                    onSubmit: onSubmit,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(String label, FoodOption foodOption, bool value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: (val) {
              setState(() {
                switch (foodOption) {
                  case FoodOption.glutenFree:
                    _isGlutenFree = val;
                    break;
                  case FoodOption.vegan:
                    _isVegan = val;
                    break;
                  case FoodOption.vegetarian:
                    _isVegetarian = val;
                    break;
                  case FoodOption.lactoseFree:
                    _isLactoseFree = val;
                    break;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
