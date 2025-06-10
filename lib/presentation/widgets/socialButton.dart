import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String? icon;
  final String label;
  final double size;
  final Color borderColor;
  final double borderRadius;
  final Color backgroundColor;
  final Future<void> Function()? onPressed;

  const SocialButton({
    super.key,
    this.icon,
    required this.label,
    required this.size,
    required this.borderColor,
    required this.borderRadius,
    required this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Image.asset(icon!, width: size, height: size),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14, // Taille du texte réduite pour tous les boutons
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}