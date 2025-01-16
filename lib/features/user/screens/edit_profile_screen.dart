import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 234 567 8900');
  final _locationController = TextEditingController(text: 'San Francisco, CA');
  DateTime _dateOfBirth = DateTime(1990, 1, 1);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: const Text('Edit Profile'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _saveChanges,
          child: Text(
            'Save',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfilePhotoSection(),
                SizedBox(height: 24.h),
                _buildPersonalInfoSection(),
                SizedBox(height: 24.h),
                _buildContactInfoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    CupertinoIcons.person_fill,
                    size: 60.sp,
                    color: AppColors.accent,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      CupertinoIcons.camera_fill,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // TODO: Implement change photo
            },
            child: Text(
              'Change Photo',
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

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
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
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                placeholder: 'Enter your full name',
              ),
              _buildDivider(),
              _buildDateField(
                label: 'Date of Birth',
                value: _formatDate(_dateOfBirth),
                onTap: _showDatePicker,
              ),
              _buildDivider(),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                placeholder: 'Enter your location',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
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
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                placeholder: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildDivider(),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                placeholder: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 8.h),
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: null,
            style: AppTypography.bodyMedium,
            placeholderStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.5),
            ),
            keyboardType: keyboardType,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 20.sp,
            color: AppColors.textLight,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: AppColors.textLight.withOpacity(0.1),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300.h,
        color: AppColors.surface,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textLight.withOpacity(0.1),
                  ),
                ),
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
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _dateOfBirth,
                maximumDate: DateTime.now(),
                minimumYear: 1900,
                onDateTimeChanged: (date) {
                  setState(() => _dateOfBirth = date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save changes
      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
