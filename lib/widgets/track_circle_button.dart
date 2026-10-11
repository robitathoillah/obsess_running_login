import 'package:flutter/material.dart';
import '../theme/track_colors.dart';

/// Tombol bulat putih kecil (back, fullscreen, dll).
class TrackCircleButton extends StatelessWidget {
  const TrackCircleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 40,
    this.iconSize = 22,
    this.iconColor = TC.slate700,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: TC.slate200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}