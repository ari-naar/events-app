import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/custom_button.dart';

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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedCutoffDate;
  TimeOfDay? _selectedCutoffTime;
  bool _isRecurring = false;
  RangeValues _ageRange = const RangeValues(18, 100);

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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(),
                    SizedBox(height: 24.h),
                    _buildParticipantLimits(),
                    SizedBox(height: 24.h),
                    _buildResponseSettings(),
                    SizedBox(height: 24.h),
                    _buildNotificationSettings(),
                    SizedBox(height: 24.h),
                    _buildAgeSettings(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
          Text(
            'Create Event',
            style: AppTypography.titleMedium,
          ),
          TextButton(
            onPressed: _handleSubmit,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Event Details', style: AppTypography.titleSmall),
        SizedBox(height: 16.h),
        CustomTextField(
          label: 'Event Name',
          hintText: 'Enter event name',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter event name' : null,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Date',
                hintText: 'Select date',
                readOnly: true,
                onTap: _selectDate,
                value: _selectedDate?.toString() ?? '',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomTextField(
                label: 'Time',
                hintText: 'Select time',
                readOnly: true,
                onTap: _selectTime,
                value: _selectedTime?.format(context) ?? '',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: 'Location',
          hintText: 'Enter location',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter location' : null,
        ),
      ],
    );
  }

  Widget _buildParticipantLimits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Participant Limits', style: AppTypography.titleSmall),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Min People',
                hintText: 'Optional',
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomTextField(
                label: 'Max People',
                hintText: 'Optional',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResponseSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Response Settings', style: AppTypography.titleSmall),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Cutoff Date',
                hintText: 'Select date',
                readOnly: true,
                onTap: _selectCutoffDate,
                value: _selectedCutoffDate?.toString() ?? '',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: CustomTextField(
                label: 'Cutoff Time',
                hintText: 'Select time',
                readOnly: true,
                onTap: _selectCutoffTime,
                value: _selectedCutoffTime?.format(context) ?? '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Event Settings', style: AppTypography.titleSmall),
        SizedBox(height: 16.h),
        SwitchListTile(
          title: const Text('Recurring Event'),
          value: _isRecurring,
          onChanged: (value) => setState(() => _isRecurring = value),
        ),
      ],
    );
  }

  Widget _buildAgeSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Age Range', style: AppTypography.titleSmall),
        SizedBox(height: 16.h),
        RangeSlider(
          values: _ageRange,
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            _ageRange.start.round().toString(),
            _ageRange.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _ageRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Min: ${_ageRange.start.round()}'),
            Text('Max: ${_ageRange.end.round()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              type: ButtonType.secondary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomButton(
              onPressed: _handleSubmit,
              text: 'Create Event',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _selectCutoffDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedCutoffDate = picked);
    }
  }

  Future<void> _selectCutoffTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedCutoffTime = picked);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle event creation
      Navigator.pop(context);
    }
  }
}
