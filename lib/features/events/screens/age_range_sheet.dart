import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class AgeRange {
  final int minAge;
  final int maxAge;

  const AgeRange({
    this.minAge = 0,
    this.maxAge = 100,
  });

  AgeRange copyWith({
    int? minAge,
    int? maxAge,
  }) {
    return AgeRange(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
    );
  }
}

class AgeRangeSheet extends StatefulWidget {
  final AgeRange initialRange;

  const AgeRangeSheet({
    super.key,
    this.initialRange = const AgeRange(),
  });

  static Future<AgeRange?> show(
    BuildContext context, {
    AgeRange initialRange = const AgeRange(),
  }) {
    return showModalBottomSheet<AgeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AgeRangeSheet(
        initialRange: initialRange,
      ),
    );
  }

  @override
  State<AgeRangeSheet> createState() => _AgeRangeSheetState();
}

class _AgeRangeSheetState extends State<AgeRangeSheet> {
  late AgeRange _range;

  @override
  void initState() {
    super.initState();
    _range = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age Range',
                    style: AppTypography.titleSmall,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        _buildAgePicker(
                          label: 'Minimum Age',
                          value: _range.minAge,
                          onChanged: (value) {
                            setState(() {
                              _range = _range.copyWith(
                                minAge: value,
                                maxAge: value > _range.maxAge
                                    ? value
                                    : _range.maxAge,
                              );
                            });
                          },
                        ),
                        Divider(
                            height: 1.h,
                            color: AppColors.textLight.withValues(alpha: 0.1)),
                        _buildAgePicker(
                          label: 'Maximum Age',
                          value: _range.maxAge,
                          onChanged: (value) {
                            setState(() {
                              _range = _range.copyWith(
                                maxAge: value,
                                minAge: value < _range.minAge
                                    ? value
                                    : _range.minAge,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
            color: Colors.black.withValues(alpha: 0.05),
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
            'Age Range',
            style: AppTypography.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context, _range),
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

  Widget _buildAgePicker({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: () => _showAgePicker(
        initialValue: value,
        onChanged: onChanged,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium,
          ),
          Text(
            '$value years',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showAgePicker({
    required int initialValue,
    required ValueChanged<int> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200.h,
        color: AppColors.background,
        child: CupertinoPicker(
          itemExtent: 32.h,
          scrollController: FixedExtentScrollController(
            initialItem: initialValue,
          ),
          onSelectedItemChanged: onChanged,
          children: List.generate(
            101,
            (index) => Center(
              child: Text('$index years'),
            ),
          ),
        ),
      ),
    );
  }
}
