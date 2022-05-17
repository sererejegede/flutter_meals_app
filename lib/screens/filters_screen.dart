import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = 'filters';
  final Map<String, bool> currentFilters;
  final void Function(Map<String, bool>) saveFilters;
  const FiltersScreen({
    Key? key,
    required this.currentFilters,
    required this.saveFilters,
  }) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final Map<String, bool> _filters = {
    'isGlutenFree': false,
    'isLactoseFree': false,
    'isVegan': false,
    'isVegetarian': false
  };

  @override
  void initState() {
    super.initState();
    _filters['isGlutenFree'] = widget.currentFilters['isGlutenFree'] as bool;
    _filters['isLactoseFree'] = widget.currentFilters['isLactoseFree'] as bool;
    _filters['isVegan'] = widget.currentFilters['isVegan'] as bool;
    _filters['isVegetarian'] = widget.currentFilters['isVegetarian'] as bool;
  }

  String manipulate(String string) {
    var prefixIndex = string.indexOf('is');
    var suffixIndex = string.indexOf('Free');
    if (prefixIndex >= 0 && suffixIndex >= 0) {
      return 'Exclude meals that contains ${string.substring(2, suffixIndex).toLowerCase()}';
    } else if (suffixIndex < 0) {
      return 'Show ${string.substring(2).toLowerCase()} meals';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(
            onPressed: () {
              widget.saveFilters(_filters);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Filters updated!'),
                ),
              );
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: _filters.entries
            .map((filter) => SwitchListTile(
                  key: ValueKey(filter.key),
                  title: Text(filter.key),
                  subtitle: Text(manipulate(filter.key)),
                  value: filter.value,
                  onChanged: (val) {
                    setState(() {
                      _filters[filter.key] = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
