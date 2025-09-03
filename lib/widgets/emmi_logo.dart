import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmmiLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final bool useAsset;
  
  const EmmiLogo({
    super.key,
    this.fontSize = 24,
    this.color,
    this.useAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useAsset) {
      String assetPath = 'assets/images/emmi-nail-Logo-4C-rot.png';
      if (color == AppColors.emmiWhite) {
        assetPath = 'assets/images/emmi-nail-Logo-4C-weiss.png';
      } else if (color == AppColors.emmiBlack) {
        assetPath = 'assets/images/emmi-nail-Logo-4C-schwarz.png';
      }
      
      return Image.asset(
        assetPath,
        height: fontSize * 2,
        fit: BoxFit.contain,
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'emmi',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600, // Silka SemiBold
              color: color ?? AppColors.emmiRed,
              fontFamily: 'Silka',
            ),
          ),
          TextSpan(
            text: '®',
            style: TextStyle(
              fontSize: fontSize * 0.5,
              fontWeight: FontWeight.w400,
              color: color ?? AppColors.emmiRed,
              fontFamily: 'Silka',
            ),
          ),
          TextSpan(
            text: ' NAIL',
            style: TextStyle(
              fontSize: fontSize * 0.75,
              fontWeight: FontWeight.w300, // Silka Light
              color: color ?? AppColors.emmiRed,
              fontFamily: 'Silka',
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
