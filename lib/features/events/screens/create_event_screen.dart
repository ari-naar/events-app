import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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

  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 18, minute: 0);
  DateTime _responseCutoff = DateTime.now();
  bool _hasWaitlist = false;
  RecurringType? _recurringType;
  NotificationSettings _notificationSettings = const NotificationSettings();
  bool _hasMinParticipants = false;
  bool _hasMaxParticipants = false;
  bool _hasMinAge = false;
  bool _hasMaxAge = false;
  File? _selectedImage;

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
                      _buildImageSection(context),
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

  Widget _buildImageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Image',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _selectedImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.xmark,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.camera_fill,
                            size: 32.sp,
                            color: AppColors.accent,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Add Event Image',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textLight,
                                    height: 1.3,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Tap to upload',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textLight.withOpacity(0.7),
                                    height: 1.3,
                                  ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Could not pick image. Please try again.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
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
              Divider(
                  height: 1.h,
                  color: AppColors.textLight.withValues(alpha: 0.1)),
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
              Divider(
                  height: 1.h,
                  color: AppColors.textLight.withValues(alpha: 0.1)),
              _buildLocationField(),
              Divider(
                  height: 1.h,
                  color: AppColors.textLight.withValues(alpha: 0.1)),
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
    String tempLocation = _locationController.text;
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
                    onPressed: () => Navigator.pop(context, ''),
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
                    onPressed: () {
                      if (tempLocation.trim().isEmpty) {
                        Navigator.pop(context, '');
                      } else {
                        Navigator.pop(context, tempLocation);
                      }
                    },
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
                initialValue: _locationController.text,
                onChanged: (value) {
                  tempLocation = value;
                },
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
                          color: AppColors.textLight.withValues(alpha: 0.2),
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
                      activeTrackColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_hasMinParticipants) ...[
                Divider(
                    height: 1.h,
                    color: AppColors.textLight.withValues(alpha: 0.1)),
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
              Divider(
                  height: 1.h,
                  color: AppColors.textLight.withValues(alpha: 0.1)),
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
                      activeTrackColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_hasMaxParticipants) ...[
                Divider(
                    height: 1.h,
                    color: AppColors.textLight.withValues(alpha: 0.1)),
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

      // Show completion screen
      _showCompletionScreen(event);
    }
  }

  void _showCompletionScreen(Event event) {
    // Close the create event modal first
    Navigator.pop(context, event);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // Success Icon and Title
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 64.h, bottom: 48.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      size: 40.sp,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Event Created Successfully',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textLight,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Share Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sharable Link
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.link,
                            size: 20.sp,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              'events.app/e/${event.id}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              final link = 'events.app/e/${event.id}';
                              await Clipboard.setData(
                                  ClipboardData(text: link));
                              if (!mounted) return;

                              // Show copy feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Link copied to clipboard',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.success,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Copy',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // Share Options
                    Text(
                      'Share via',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildShareOption(
                          icon: CupertinoIcons.chat_bubble_fill,
                          label: 'Messages',
                          color: const Color(0xFF25D366),
                          onTap: () => _shareViaWhatsApp(event),
                        ),
                        _buildShareOption(
                          icon: CupertinoIcons.photo_fill,
                          label: 'Instagram',
                          color: const Color(0xFFE4405F),
                          onTap: () => _shareViaInstagram(event),
                        ),
                        _buildShareOption(
                          icon: CupertinoIcons.at,
                          label: 'X',
                          color: Colors.black,
                          onTap: () => _shareViaX(event),
                        ),
                        _buildShareOption(
                          icon: CupertinoIcons.f_cursive,
                          label: 'Facebook',
                          color: const Color(0xFF1877F2),
                          onTap: () => _shareViaFacebook(event),
                        ),
                        _buildShareOption(
                          icon: CupertinoIcons.mail_solid,
                          label: 'Email',
                          color: AppColors.textLight,
                          onTap: () => _shareViaEmail(event),
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),

                    // Share Button
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        onPressed: () => _shareNative(event),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.share,
                              size: 20.sp,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'More Options',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // View Button
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(16.r),
                        onPressed: () {
                          Navigator.pop(context); // Close completion screen
                        },
                        child: Text(
                          'View Event',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
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
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              HapticFeedback.lightImpact();
              _animateShareButton(context, onTap);
            },
            child: Column(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _animateShareButton(BuildContext context, VoidCallback onTap) {
    // Scale animation on tap
    TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.9),
      duration: const Duration(milliseconds: 100),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      onEnd: () {
        onTap();
      },
    );
  }

  String _formatEventDetails(Event event) {
    final buffer = StringBuffer();
    buffer.writeln('🎉 ${event.name}');
    buffer.writeln('📅 ${_formatDateTime(event.date)}');
    buffer.writeln('📍 ${event.location}');

    if (event.maxParticipants != null) {
      buffer.writeln('👥 Limited to ${event.maxParticipants} participants');
    }

    if (event.minAge != null || event.maxAge != null) {
      final ageRange = [
        if (event.minAge != null) '${event.minAge}+',
        if (event.maxAge != null) 'up to ${event.maxAge}',
      ].join(' ');
      buffer.writeln('🔞 Age range: $ageRange');
    }

    return buffer.toString();
  }

  Future<void> _shareViaWhatsApp(Event event) async {
    try {
      final url = 'events.app/e/${event.id}';
      final message = _formatEventDetails(event);
      final whatsappUrl = Uri.parse(
        'whatsapp://send?text=${Uri.encodeComponent('$message\n\nJoin here: $url')}',
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('WhatsApp Not Found'),
          content: const Text(
              'Please make sure WhatsApp is installed on your device.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareViaInstagram(Event event) async {
    try {
      final url = 'events.app/e/${event.id}';
      final instagramUrl = Uri.parse('instagram://share');

      if (await canLaunchUrl(instagramUrl)) {
        await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Instagram';
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Instagram Not Found'),
          content: const Text(
              'Please make sure Instagram is installed on your device.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareViaX(Event event) async {
    try {
      final url = 'events.app/e/${event.id}';
      final message = _formatEventDetails(event);
      final twitterUrl = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('$message\n\nJoin here: $url')}',
      );

      if (await canLaunchUrl(twitterUrl)) {
        await launchUrl(twitterUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch X';
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Browser Not Found'),
          content: const Text('Unable to open X. Please try again later.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareViaFacebook(Event event) async {
    try {
      final url = 'events.app/e/${event.id}';
      final facebookUrl = Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}',
      );

      if (await canLaunchUrl(facebookUrl)) {
        await launchUrl(facebookUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Facebook';
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Browser Not Found'),
          content:
              const Text('Unable to open Facebook. Please try again later.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareViaEmail(Event event) async {
    try {
      final url = 'events.app/e/${event.id}';
      final message = _formatEventDetails(event);
      final subject = Uri.encodeComponent('Join me at ${event.name}!');
      final body = Uri.encodeComponent('$message\n\nJoin here: $url');
      final emailUrl = Uri.parse('mailto:?subject=$subject&body=$body');

      if (await canLaunchUrl(emailUrl)) {
        await launchUrl(emailUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch email';
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Email Not Found'),
          content: const Text('Unable to open email. Please try again later.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareNative(Event event) async {
    try {
      final url = 'events.app/e/${event.id}';
      final message = _formatEventDetails(event);
      await Share.share(
        '$message\n\nJoin here: $url',
        subject: 'Join me at ${event.name}!',
      );
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Sharing Failed'),
          content: const Text(
              'Unable to share at this time. Please try again later.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
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
