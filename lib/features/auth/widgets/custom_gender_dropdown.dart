import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_text_form_field.dart';
import 'package:sakina/generated/locale_keys.g.dart';

class CustomGenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomGenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: LocaleKeys.select_gender.tr(),
      labelText: LocaleKeys.signup_gender_label.tr(),
      //I send the dropdown as a child to the text form field 
      child: DropdownButtonFormField<String>(
        initialValue: value,
        onChanged: onChanged,
        dropdownColor: AppColors.themeColor,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        decoration: InputDecoration(
          fillColor: AppColors.textFieldBackground,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.primaryBeig),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.primaryBrown),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Male')),
          DropdownMenuItem(value: 'female', child: Text('Female')),
        ],
      ),
    );
  }
}