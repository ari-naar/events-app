import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: type == ButtonType.primary
              ? AppColors.primary
              : Colors.transparent,
          foregroundColor:
              type == ButtonType.primary ? Colors.white : AppColors.primary,
          elevation: 0,
          side: type == ButtonType.secondary
              ? BorderSide(color: AppColors.primary)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          text,
          style: AppTypography.labelLarge.copyWith(
            color:
                type == ButtonType.primary ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
