import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  const CustomDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
        ),
      ],
    );
  }
}
