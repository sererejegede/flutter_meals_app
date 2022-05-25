import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/categories.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = 'categories';

  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  var _isFetching = false;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      setState(() {
        _isFetching = true;
      });
      context.read<Categories>().getAllCategories().then((_) {
        setState(() {
          _isFetching = false;
        });
      });
    }
    _initialized = true;
    _categories = context.watch<Categories>().categories;
  }

  @override
  Widget build(BuildContext context) {
    return _isFetching
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              children: _categories
                  .map((category) => CategoryItem(
                        category: category,
                      ))
                  .toList(),
            ),
          );
  }
}
