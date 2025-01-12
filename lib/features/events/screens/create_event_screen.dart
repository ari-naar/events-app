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
  final _imageController = TextEditingController();
  final _minParticipantsController = TextEditingController(text: '2');
  final _maxParticipantsController = TextEditingController(text: '10');
  final _minAgeController = TextEditingController(text: '0');
  final _maxAgeController = TextEditingController(text: '100');
  final List<String> _recentLocations = [
    'Central Park',
    'Brooklyn Bridge',
    'Times Square',
    'Battery Park',
  ];

  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 18, minute: 0);
  int _minParticipants = 2;
  int _maxParticipants = 10;
  DateTime _responseCutoff = DateTime.now();
  bool _hasWaitlist = false;
  RecurringType? _recurringType;
  NotificationSettings _notificationSettings = const NotificationSettings();
  AgeRange _ageRange = const AgeRange();
  bool _hasMinParticipants = false;
  bool _hasMaxParticipants = false;
  bool _hasMinAge = false;
  bool _hasMaxAge = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _minParticipantsController.dispose();
    _maxParticipantsController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextFormField(
              controller: _nameController,
              style: AppTypography.titleMedium,
              decoration: InputDecoration(
                hintText: 'Event Name',
                hintStyle: AppTypography.titleMedium.copyWith(
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an event name';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(),
                      SizedBox(height: 24.h),
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Image',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.accent.withOpacity(0.1),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Implement image picker
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.camera,
                      size: 48.sp,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add Event Image',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_imageController.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: InputBorder.none,
              ),
            ),
          ),
      ],
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
              _buildLocationField(),
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

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Location',
        border: InputBorder.none,
        prefixIcon: Icon(
          CupertinoIcons.map_pin,
          size: 20.sp,
          color: AppColors.textLight,
        ),
      ),
      onTap: _showLocationPicker,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a location';
        }
        return null;
      },
    );
  }

  void _showLocationPicker() async {
    final location = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
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
                    'Select Location',
                    style: AppTypography.titleMedium,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () =>
                        Navigator.pop(context, _locationController.text),
                    child: Text(
                      'Done',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextFormField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _locationController.text = value;
                  });
                },
                initialValue: _locationController.text,
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  prefixIcon: Icon(
                    CupertinoIcons.map_pin,
                    size: 20.sp,
                    color: AppColors.textLight,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Map',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.textLight.withOpacity(0.2),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16.w,
                      bottom: 16.h,
                      child: FloatingActionButton(
                        onPressed: () {
                          // TODO: Implement current location
                        },
                        backgroundColor: AppColors.accent,
                        child: Icon(
                          CupertinoIcons.location_fill,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (location != null) {
      setState(() {
        _locationController.text = location;
      });
    }
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set Minimum',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _hasMinParticipants,
                      onChanged: (value) {
                        setState(() {
                          _hasMinParticipants = value;
                        });
                      },
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_hasMinParticipants) ...[
                Divider(
                    height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextFormField(
                    controller: _minParticipantsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Participants',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (!_hasMinParticipants) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter minimum participants';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 1) {
                        return 'Please enter a valid number';
                      }
                      if (_hasMaxParticipants) {
                        final max =
                            int.tryParse(_maxParticipantsController.text);
                        if (max != null && number > max) {
                          return 'Minimum cannot be greater than maximum';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set Maximum',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _hasMaxParticipants,
                      onChanged: (value) {
                        setState(() {
                          _hasMaxParticipants = value;
                        });
                      },
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_hasMaxParticipants) ...[
                Divider(
                    height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextFormField(
                    controller: _maxParticipantsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Participants',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (!_hasMaxParticipants) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter maximum participants';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 1) {
                        return 'Please enter a valid number';
                      }
                      if (_hasMinParticipants) {
                        final min =
                            int.tryParse(_minParticipantsController.text);
                        if (min != null && number < min) {
                          return 'Maximum cannot be less than minimum';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
              if (_hasMaxParticipants) ...[
                Divider(
                    height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set Minimum Age',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _hasMinAge,
                      onChanged: (value) {
                        setState(() {
                          _hasMinAge = value;
                        });
                      },
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_hasMinAge) ...[
                Divider(
                    height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextFormField(
                    controller: _minAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Age',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (!_hasMinAge) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter minimum age';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 0) {
                        return 'Please enter a valid age';
                      }
                      if (_hasMaxAge) {
                        final max = int.tryParse(_maxAgeController.text);
                        if (max != null && number > max) {
                          return 'Minimum age cannot be greater than maximum';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
              Divider(height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Set Maximum Age',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _hasMaxAge,
                      onChanged: (value) {
                        setState(() {
                          _hasMaxAge = value;
                        });
                      },
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_hasMaxAge) ...[
                Divider(
                    height: 1.h, color: AppColors.textLight.withOpacity(0.1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextFormField(
                    controller: _maxAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Age',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (!_hasMaxAge) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please enter maximum age';
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 0) {
                        return 'Please enter a valid age';
                      }
                      if (_hasMinAge) {
                        final min = int.tryParse(_minAgeController.text);
                        if (min != null && number < min) {
                          return 'Maximum age cannot be less than minimum';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ],
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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final event = Event(
        id: '', // Will be generated by the backend
        name: _nameController.text,
        date: _date,
        location: _locationController.text,
        minParticipants: _hasMinParticipants
            ? int.parse(_minParticipantsController.text)
            : null,
        maxParticipants: _hasMaxParticipants
            ? int.parse(_maxParticipantsController.text)
            : null,
        responseCutoff: _responseCutoff,
        hasWaitlist: _hasWaitlist && _hasMaxParticipants,
        participants: const [],
        waitlist: const [],
        minAge: _hasMinAge ? int.parse(_minAgeController.text) : null,
        maxAge: _hasMaxAge ? int.parse(_maxAgeController.text) : null,
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
