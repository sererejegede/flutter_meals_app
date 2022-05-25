import 'package:flutter/material.dart';

import 'modal.dart';

typedef T = List<String>;

class MultiInputFormField extends FormField<T> {
  MultiInputFormField({
    Key? key,
    required String labelText,
    required BuildContext context,
    required FormFieldSetter<T> onSaved,
  }) : super(
          key: key,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<T> state) {
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => Modal(
                        child: MultiInput(
                          state: state,
                          labelText: labelText,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      state.value?.isNotEmpty ?? false
                          ? (state.value ?? []).join(', ')
                          : 'Add $labelText',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  right: 8,
                  top: 12,
                  child: Icon(
                    Icons.select_all,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        );

  @override
  _MultiInputFormFieldState createState() => _MultiInputFormFieldState();
}

class _MultiInputFormFieldState extends FormFieldState<T> {
  @override
  MultiInputFormField get widget => super.widget as MultiInputFormField;

  @override
  void didChange(T? list) {
    super.didChange(list);
  }
}

class MultiInput extends StatefulWidget {
  final FormFieldState<T> state;
  final String labelText;
  const MultiInput({
    Key? key,
    required this.state,
    required this.labelText,
  }) : super(key: key);

  @override
  State<MultiInput> createState() => _MultiInputState();
}

class _MultiInputState extends State<MultiInput> {
  final _controller = TextEditingController();
  List<String> _values = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _values = widget.state.value ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Add ${widget.labelText} for making the meal.',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RaleWay',
                ),
              ),
            ),
            Stack(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: widget.labelText),
                ),
                Positioned(
                  right: 5,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _values.add(_controller.text);
                      });
                      _controller.clear();
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Text(
                'Re-orderable list',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RaleWay',
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 250,
                minHeight: 100,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(.3)),
              ),
              child: ReorderableListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                shrinkWrap: true,
                children: [
                  for (int index = 0; index < _values.length; index += 1)
                    Container(
                      key: Key('$index'),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(.3),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _values[index],
                              style: const TextStyle(fontSize: 16),
                              softWrap: true,
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _values.removeAt(index);
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(context).errorColor,
                            ),
                          )
                        ],
                      ),
                    )
                ],
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) newIndex -= 1;
                    final String item = _values.removeAt(oldIndex);
                    _values.insert(newIndex, item);
                  });
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.state.didChange(_values);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add Steps',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
