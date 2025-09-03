import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmmiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double? angle;
  
  const EmmiButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.angle,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.emmiWhite,
        foregroundColor: AppColors.emmiRed,
        side: BorderSide(color: AppColors.emmiRed, width: 1),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Silka',
            fontWeight: FontWeight.w500, // Silka Medium
            fontSize: 16,
          ),
        ),
      ),
    );

    if (angle != null) {
      return Transform.rotate(
        angle: angle! * (3.14159 / 180),
        child: button,
      );
    }
    
    return button;
  }
}
