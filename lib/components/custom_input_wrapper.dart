import 'package:flutter/material.dart';

class CustomInputWrapper extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Widget? trailingIcon;
  const CustomInputWrapper({
    Key? key,
    required this.child,
    required this.onTap,
    this.trailingIcon = const Icon(
      Icons.select_all,
      color: Colors.grey,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 48,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: child,
          ),
        ),
        if (trailingIcon != null)
          Positioned(
            right: 8,
            top: 12,
            child: trailingIcon!,
          )
      ],
    );
  }
}
