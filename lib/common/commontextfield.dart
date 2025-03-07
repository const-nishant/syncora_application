import 'package:flutter/material.dart';

class Commontextfield extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final FocusNode focusNode;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const Commontextfield(
      {super.key,
      required this.controller,
      required this.keyboardType,
      required this.hintText,
      required this.obscureText,
      required this.readOnly,
      required this.focusNode,
      this.maxLength,
      this.validator,
      this.onTap,
      this.prefixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      maxLength: maxLength,
      obscureText: obscureText,
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor: Theme.of(context).colorScheme.primary,
        suffixIcon: suffixIcon,
        suffixIconColor: Theme.of(context).colorScheme.primary,
        counterText: "",
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.transparent,
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 10.0,
        ),
      ),
    );
  }
}
