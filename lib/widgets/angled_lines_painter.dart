import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';

// Brand Guideline'daki 8.5° açı desenini oluşturan CustomPainter
class AngledLinesPainter extends CustomPainter {
  final Color? lineColor;
  final double? strokeWidth;
  final double? spacing;
  
  const AngledLinesPainter({
    this.lineColor,
    this.strokeWidth = 1.5,
    this.spacing = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (lineColor ?? AppColors.emmiWhite).withOpacity(0.1)
      ..strokeWidth = strokeWidth!;

    const angle = 8.5 * (3.14159 / 180); // 8.5° to radians - Brand Guideline
    final lineSpacing = spacing!;
    
    // Calculate diagonal lines across the container with 8.5° angle
    for (double i = -size.height; i < size.width + size.height; i += lineSpacing) {
      final startX = i;
      final startY = 0.0;
      final endX = i + size.height * (1 / tan(angle));
      final endY = size.height;
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}