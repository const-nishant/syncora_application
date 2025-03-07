import 'package:flutter/material.dart';

class LargeButton extends StatefulWidget {
  final void Function() onPressed;
  final String text;
  const LargeButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<LargeButton> createState() => _LargeButtonState();
}

class _LargeButtonState extends State<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        fixedSize: const Size(500, 50),
        backgroundColor: Theme.of(context)
                .elevatedButtonTheme
                .style
                ?.backgroundColor
                ?.resolve({}) ??
            Color(0x008d4612),
        foregroundColor: Theme.of(context)
                .elevatedButtonTheme
                .style
                ?.foregroundColor
                ?.resolve({}) ??
            Colors.white,
      ),
      child: Text(
        widget.text,
        style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
