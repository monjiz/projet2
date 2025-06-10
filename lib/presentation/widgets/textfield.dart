import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText; // Nouvelle propriété
  final Color textColor;
  final Color hintColor;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Widget? suffixIcon; // Nouvelle propriété

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false, // Par défaut false
    required this.textColor,
    required this.hintColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.padding,
    this.suffixIcon, // Peut être null
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false, // Respecte isPassword
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor, fontSize: 16),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: backgroundColor,
        contentPadding: padding,
        suffixIcon: suffixIcon, // Passe l'icône
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
        ),
      ),
    );
  }
}