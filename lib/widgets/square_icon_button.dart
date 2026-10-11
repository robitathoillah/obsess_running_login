import 'package:flutter/material.dart';
import '../theme/fit_colors.dart';

/// Tombol kotak putih (40x40) yang dipakai di header: kembali, kalender, info.
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = FitColors.slate700,
    this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: FitColors.slate200),
            boxShadow: FitColors.softShadow,
          ),
          child: Icon(icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}
