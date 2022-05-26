import 'package:flutter/material.dart';
import 'package:meals/components/custom_input_wrapper.dart';

class MultiSelectFormField<T> extends FormField<List<T>> {
  MultiSelectFormField({
    Key? key,
    required String labelText,
    List<T>? selectedValues,
    required List<T> options,
    required Widget Function(T) titleBuilder,
    required FormFieldSetter<List<T>> onSaved,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: selectedValues,
          builder: (FormFieldState<List<T>> state) {
            return MultiSelect<T>(
              labelText: labelText,
              options: options,
              selectedValues: selectedValues ?? [],
              titleBuilder: titleBuilder,
              onChanged: state.didChange,
            );
          },
        );
  @override
  _MultiSelectFormFieldState<T> createState() => _MultiSelectFormFieldState();
}

class _MultiSelectFormFieldState<T> extends FormFieldState<List<T>> {
  @override
  MultiSelectFormField<T> get widget => super.widget as MultiSelectFormField<T>;

  @override
  void didChange(List<T>? values) {
    super.didChange(values);
    if (widget.onSaved != null) {
      widget.onSaved!(values);
    }
  }
}

class MultiSelect<T> extends StatelessWidget {
  final List<T> options;
  final List<T> selectedValues;
  final Function(List<T>) onChanged;
  final Widget Function(T) titleBuilder;
  final String labelText;
  const MultiSelect({
    Key? key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.titleBuilder,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: selectedValues.map((val) {
                    var p = [titleBuilder(val)];
                    if (selectedValues.last != val) {
                      p.add(const Icon(Icons.done_all_sharp));
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: p,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          CustomInputWrapper(
            onTap: () {},
            trailingIcon: null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                iconSize: 26,
                menuMaxHeight: 400,
                isExpanded: true,
                isDense: true,
                value: null,
                items: options
                    .map(
                      (option) => DropdownMenuItem<T>(
                        value: option,
                        child: CustomCheckboxTile(
                          title: titleBuilder(option),
                          selected: selectedValues.contains(option),
                          onChanged: (val) {
                            if (selectedValues.contains(option)) {
                              selectedValues.remove(option);
                            } else {
                              selectedValues.add(option);
                            }
                            onChanged(selectedValues);
                          },
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCheckboxTile extends StatefulWidget {
  final Widget title;
  final Function(bool) onChanged;
  final bool selected;
  const CustomCheckboxTile({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.selected,
  }) : super(key: key);

  @override
  State<CustomCheckboxTile> createState() => _CustomCheckboxTileState();
}

class _CustomCheckboxTileState extends State<CustomCheckboxTile> {
  bool _checked = false;
  @override
  void initState() {
    super.initState();
    _checked = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        controlAffinity: ListTileControlAffinity.leading,
        value: _checked,
        selected: _checked,
        title: widget.title,
        onChanged: (val) {
          widget.onChanged(val ?? false);
          setState(() {
            _checked = val ?? false;
          });
        },
      ),
    );
  }
}
