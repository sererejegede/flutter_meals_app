import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool loading;
  const Button({
    Key? key,
    required this.loading,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
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
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : null,
          )
        ],
      ),
    );
  }
}
