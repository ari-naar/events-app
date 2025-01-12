import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../core/models/event.dart';
import 'age_range_sheet.dart';
import 'notification_settings_sheet.dart';
import 'recurring_options_sheet.dart';

class CreateEventBottomSheet extends StatefulWidget {
  const CreateEventBottomSheet({super.key});

  static Future<Event?> show(BuildContext context) {
    return showModalBottomSheet<Event>(
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
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 18, minute: 0);
  int _minParticipants = 2;
  int _maxParticipants = 10;
  DateTime _responseCutoff = DateTime.now();
  bool _hasWaitlist = false;
  RecurringType? _recurringType;
  NotificationSettings _notificationSettings = const NotificationSettings();
  AgeRange _ageRange = const AgeRange();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
            child: Form(
              key: _formKey,
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInfoSection(),
                      SizedBox(height: 24.h),
                      _buildParticipantsSection(),
                      SizedBox(height: 24.h),
                      _buildResponseSection(),
                      SizedBox(height: 24.h),
                      _buildRecurringSection(),
                      SizedBox(height: 24.h),
                      _buildNotificationsSection(),
                      SizedBox(height: 24.h),
                      _buildAgeRangeSection(),
                      SizedBox(height: 32.h),
                      _buildCreateButton(),
                      SizedBox(height: 16.h),
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
            'Create Event',
            style: AppTypography.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _submitForm,
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

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                onPressed: _showDatePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      _formatDate(_date),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                onPressed: _showTimePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      _formatTime(_time),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participants',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                onPressed: () => _showParticipantsPicker(isMin: true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Minimum Participants',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      '$_minParticipants',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                onPressed: () => _showParticipantsPicker(isMin: false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Maximum Participants',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      '$_maxParticipants',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enable Waitlist',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _hasWaitlist,
                      onChanged: (value) {
                        setState(() {
                          _hasWaitlist = value;
                        });
                      },
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Response',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            onPressed: _showResponseCutoffPicker,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Response Cutoff',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  _formatDateTime(_responseCutoff),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recurring',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            onPressed: _showRecurringOptions,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Repeat',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  _recurringType?.label ?? 'Never',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            onPressed: _showNotificationSettings,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification Settings',
                  style: AppTypography.bodyMedium,
                ),
                Icon(
                  CupertinoIcons.right_chevron,
                  size: 20.sp,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age Range',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            onPressed: _showAgeRangePicker,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Age Limits',
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  '${_ageRange.minAge} - ${_ageRange.maxAge} years',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Create Event',
          style: AppTypography.titleSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _date = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _time.hour,
          _time.minute,
        );
      });
    }
  }

  void _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() {
        _time = picked;
        _date = DateTime(
          _date.year,
          _date.month,
          _date.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _showParticipantsPicker({required bool isMin}) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200.h,
        color: AppColors.background,
        child: CupertinoPicker(
          itemExtent: 32.h,
          scrollController: FixedExtentScrollController(
            initialItem: isMin ? _minParticipants - 1 : _maxParticipants - 1,
          ),
          onSelectedItemChanged: (index) {
            setState(() {
              if (isMin) {
                _minParticipants = index + 1;
                if (_minParticipants > _maxParticipants) {
                  _maxParticipants = _minParticipants;
                }
              } else {
                _maxParticipants = index + 1;
                if (_maxParticipants < _minParticipants) {
                  _minParticipants = _maxParticipants;
                }
              }
            });
          },
          children: List.generate(
            100,
            (index) => Center(child: Text('${index + 1}')),
          ),
        ),
      ),
    );
  }

  void _showResponseCutoffPicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _responseCutoff,
      firstDate: DateTime.now(),
      lastDate: _date,
    );
    if (picked != null) {
      setState(() {
        _responseCutoff = picked;
      });
    }
  }

  void _showRecurringOptions() async {
    final type = await RecurringOptionsSheet.show(context);
    if (type != null) {
      setState(() {
        _recurringType = type;
      });
    }
  }

  void _showNotificationSettings() async {
    final settings = await NotificationSettingsSheet.show(
      context,
      initialSettings: _notificationSettings,
    );
    if (settings != null) {
      setState(() {
        _notificationSettings = settings;
      });
    }
  }

  void _showAgeRangePicker() async {
    final range = await AgeRangeSheet.show(
      context,
      initialRange: _ageRange,
    );
    if (range != null) {
      setState(() {
        _ageRange = range;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final event = Event(
        id: '', // Will be generated by the backend
        name: _nameController.text,
        date: _date,
        location: _locationController.text,
        minParticipants: _minParticipants,
        maxParticipants: _maxParticipants,
        responseCutoff: _responseCutoff,
        hasWaitlist: _hasWaitlist,
        participants: const [],
        waitlist: const [],
      );
      Navigator.pop(context, event);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
  }
}
