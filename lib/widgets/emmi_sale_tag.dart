import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmmiSaleTag extends StatelessWidget {
  final String text;
  final double? angle;
  
  const EmmiSaleTag({
    super.key,
    required this.text,
    this.angle = 8.5, // Brand Guideline'daki 8.5° açı
  });

  @override
  Widget build(BuildContext context) {
    Widget tag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.emmiRed,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.emmiWhite,
          fontWeight: FontWeight.w600, // Silka SemiBold
          fontStyle: FontStyle.italic,
          fontFamily: 'Silka',
          fontSize: 12,
        ),
      ),
    );

    if (angle != null) {
      return Transform.rotate(
        angle: angle! * (3.14159 / 180),
        child: tag,
      );
    }
    
    return tag;
  }
}
