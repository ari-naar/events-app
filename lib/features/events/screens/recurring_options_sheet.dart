import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

enum RecurringType {
  never('Never'),
  daily('Daily'),
  weekly('Weekly'),
  monthly('Monthly'),
  custom('Custom');

  final String label;
  const RecurringType(this.label);
}

class RecurringOptionsSheet extends StatefulWidget {
  const RecurringOptionsSheet({super.key});

  static Future<RecurringType?> show(BuildContext context) {
    return showModalBottomSheet<RecurringType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RecurringOptionsSheet(),
    );
  }

  @override
  State<RecurringOptionsSheet> createState() => _RecurringOptionsSheetState();
}

class _RecurringOptionsSheetState extends State<RecurringOptionsSheet> {
  RecurringType _selectedType = RecurringType.never;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: RecurringType.values.map((type) {
                      return Column(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            onPressed: () {
                              setState(() => _selectedType = type);
                              Navigator.pop(context, type);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  type.label,
                                  style: AppTypography.bodyMedium,
                                ),
                                if (_selectedType == type)
                                  Icon(
                                    CupertinoIcons.check_mark,
                                    color: AppColors.accent,
                                    size: 20.sp,
                                  ),
                              ],
                            ),
                          ),
                          if (type != RecurringType.values.last)
                            Divider(
                              height: 1.h,
                              indent: 16.w,
                              color: AppColors.textLight.withOpacity(0.1),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          Text(
            'Repeat',
            style: AppTypography.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context, _selectedType),
            child: Text(
              'Done',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
