import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class CreateEventBottomSheet extends StatefulWidget {
  const CreateEventBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateEventBottomSheet(),
    );
  }

  @override
  State<CreateEventBottomSheet> createState() => _CreateEventBottomSheetState();
}

class _CreateEventBottomSheetState extends State<CreateEventBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedCutoffDate = DateTime.now();
  TimeOfDay _selectedCutoffTime = TimeOfDay.now();
  bool _isRecurring = false;
  RangeValues _ageRange = const RangeValues(18, 100);
  int _minPeople = 1;
  int _maxPeople = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventBasics(),
                      _buildDateTimeSection(),
                      _buildLocationSection(),
                      _buildParticipantsSection(),
                      _buildResponseSection(),
                      _buildSettingsSection(),
                    ],
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
            'New Event',
            style: AppTypography.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _handleSubmit,
            child: Text(
              'Create',
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

  Widget _buildEventBasics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        CupertinoTextField(
          placeholder: 'Event Name',
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date & Time', style: AppTypography.titleSmall),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildDateTimeTile(
                'Date',
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                onTap: () => _showDatePicker(context),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              _buildDateTimeTile(
                'Time',
                _selectedTime.format(context),
                onTap: () => _showTimePicker(context),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: AppTypography.titleSmall),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            onPressed: () {
              // TODO: Implement location picker
            },
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.location,
                  color: AppColors.textLight,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Add Location',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors.textLight,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Participants', style: AppTypography.titleSmall),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Minimum', style: AppTypography.bodyMedium),
                  SizedBox(
                    width: 100.w,
                    child: CupertinoTextField(
                      controller:
                          TextEditingController(text: _minPeople.toString()),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Maximum', style: AppTypography.bodyMedium),
                  SizedBox(
                    width: 100.w,
                    child: CupertinoTextField(
                      controller:
                          TextEditingController(text: _maxPeople.toString()),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildResponseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Response Settings', style: AppTypography.titleSmall),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildDateTimeTile(
                'Cutoff Date',
                '${_selectedCutoffDate.day}/${_selectedCutoffDate.month}/${_selectedCutoffDate.year}',
                onTap: () => _showCutoffDatePicker(context),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              _buildDateTimeTile(
                'Cutoff Time',
                _selectedCutoffTime.format(context),
                onTap: () => _showCutoffTimePicker(context),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Additional Settings', style: AppTypography.titleSmall),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recurring Event', style: AppTypography.bodyMedium),
                    CupertinoSwitch(
                      value: _isRecurring,
                      onChanged: (value) =>
                          setState(() => _isRecurring = value),
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_isRecurring) ...[
                Divider(
                    height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
                _buildDateTimeTile(
                  'Repeat',
                  'Weekly',
                  onTap: () {
                    // TODO: Implement repeat options
                  },
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildDateTimeTile(String title, String value,
      {required VoidCallback onTap}) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.bodyMedium),
          Row(
            children: [
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.textLight,
                size: 16.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216.h,
        padding: EdgeInsets.only(top: 6.h),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => _selectedDate = newDate);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216.h,
        padding: EdgeInsets.only(top: 6.h),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now().applied(_selectedTime),
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(
                  () => _selectedTime = TimeOfDay.fromDateTime(newDateTime));
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showCutoffDatePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216.h,
        padding: EdgeInsets.only(top: 6.h),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: _selectedCutoffDate,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              setState(() => _selectedCutoffDate = newDate);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showCutoffTimePicker(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216.h,
        padding: EdgeInsets.only(top: 6.h),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now().applied(_selectedCutoffTime),
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() =>
                  _selectedCutoffTime = TimeOfDay.fromDateTime(newDateTime));
            },
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Handle event creation
      Navigator.pop(context);
    }
  }
}

extension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(
      year,
      month,
      day,
      time.hour,
      time.minute,
    );
  }
}
