import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({Key? key}) : super(key: key);

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  late String _title;
  late String _color;
  final _formKey = GlobalKey<FormState>();
  var _submitting = false;

  String _colorName(int colorValue) {
    if (colorValue == Colors.red.value) return 'Red';
    if (colorValue == Colors.pink.value) return 'Pink';
    if (colorValue == Colors.purple.value) return 'Purple';
    if (colorValue == Colors.deepPurple.value) return 'Deep Purple';
    if (colorValue == Colors.indigo.value) return 'Indigo';
    if (colorValue == Colors.blue.value) return 'Blue';
    if (colorValue == Colors.lightBlue.value) return 'Light Blue';
    if (colorValue == Colors.cyan.value) return 'Cyan';
    if (colorValue == Colors.teal.value) return 'Teal';
    if (colorValue == Colors.green.value) return 'Green';
    if (colorValue == Colors.lightGreen.value) return 'Light Green';
    if (colorValue == Colors.lime.value) return 'Lime';
    if (colorValue == Colors.yellow.value) return 'Yellow';
    if (colorValue == Colors.amber.value) return 'Amber';
    if (colorValue == Colors.orange.value) return 'Orange';
    if (colorValue == Colors.deepOrange.value) return 'Deep Orange';
    if (colorValue == Colors.brown.value) return 'Brown';
    if (colorValue == Colors.blueGrey.value) return 'Blue Grey';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 26,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Add New Category',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
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
          DropdownButtonFormField<String>(
              menuMaxHeight: 500,
              decoration: const InputDecoration(
                labelText: 'Color',
              ),
              items: Colors.primaries
                  .map(
                    (color) => DropdownMenuItem(
                      value: color.value.toString(),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            color: color,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            _colorName(
                              color.value,
                            ),
                            style: TextStyle(color: color),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                _color = val!;
              }),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_submitting) return;
              setState(() {
                _submitting = true;
              });
              _formKey.currentState?.save();
              await context.read<Categories>().addCategory(_title, _color);
              setState(() {
                _submitting = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 12,
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: _submitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : null,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
