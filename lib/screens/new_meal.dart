import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/categories.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../components/multi_input.dart';
import '../models/category.dart';
import '../providers/meals.dart';

class NewMeal extends StatefulWidget {
  static const routeName = 'new_meal';
  const NewMeal({Key? key}) : super(key: key);

  @override
  State<NewMeal> createState() => _NewMealState();
}

class _NewMealState extends State<NewMeal> {
  final _formKey = GlobalKey<FormState>();
  late Category _category;

  late dynamic _selectedCategories = [];
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
    _category = ModalRoute.of(context)?.settings.arguments as Category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Add a new ',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 22,
                      fontFamily: 'RaleWay',
                    ),
                    children: [
                      TextSpan(
                        text: _category.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' meal')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onSaved: (val) {
                    _title = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(
                  height: 16,
                ),
                MultiSelectBottomSheetField(
                  initialChildSize: 0.6,
                  buttonIcon: const Icon(
                    Icons.category,
                    color: Colors.grey,
                  ),
                  chipDisplay: MultiSelectChipDisplay.none(),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  items: context
                      .read<Categories>()
                      .categories
                      .map(
                        (category) => MultiSelectItem(
                          category,
                          category.title,
                        ),
                      )
                      .toList(),
                  onConfirm: (val) {
                    setState(() {
                      _selectedCategories = val as dynamic;
                    });
                  },
                  onSaved: (val) {
                    // _selectedCategories = val as dynamic;
                  },
                  buttonText: Text(
                    _selectedCategories.isNotEmpty
                        ? _selectedCategories
                            .map((cat) => cat.title)
                            .toList()
                            .join(', ')
                        : 'Choose other categories',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedCategories.isNotEmpty
                          ? Colors.black.withOpacity(.9)
                          : Colors.black.withOpacity(.6),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Affordability>(
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
                  onSaved: (val) {
                    _duration = val!;
                  },
                  decoration: const InputDecoration(labelText: 'Duration'),
                ),
                const SizedBox(
                  height: 16,
                ),
                MultiInputFormField(
                  labelText: 'Steps',
                  context: context,
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
                    buildCheckbox('Gluten free?', (val) {
                      setState(() {
                        _isGlutenFree = val;
                      });
                    }),
                    buildCheckbox('Lactose free?', (val) {
                      setState(() {
                        _isLactoseFree = val;
                      });
                    }),
                    buildCheckbox('Vegan', (val) {
                      setState(() {
                        _isVegan = val;
                      });
                    }),
                    buildCheckbox('Vegetarian', (val) {
                      setState(() {
                        _isVegetarian = val;
                      });
                    }),
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
    );
  }

  Widget buildCheckbox(String label, Function(bool val) onChanged) {
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
          Switch(value: _isGlutenFree, onChanged: onChanged),
        ],
      ),
    );
  }
}
