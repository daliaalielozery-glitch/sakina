import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/profile_header.dart';
import 'package:sakina/features/profiles/ui/widgets/preferences_section.dart';
import 'package:sakina/features/profiles/ui/widgets/privacy_section.dart';
import 'package:sakina/features/profiles/ui/widgets/split_bill_section.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _showProfileToPublic = true;
  bool _electricitySplit = true;
  bool _waterSplit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: Myappbar(
        showProfile: false,
        title: 'Sakina',
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ProfileHeader(
              name: 'Youssef Mansour',
              university: 'American University in Cairo',
              bio:
                  'Architecture student focused on sustainable heritage preservation. Looking for a quiet, organized space with like-minded creative souls. Low-key, coffee enthusiast, and occasional night owl.',
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF2yaox2cALIq_yyd-9qEyovEsficJr7X9QQ&s',
            ),
            SizedBox(height: 16.h),
            // Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryBeig,
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Text(
                'Verified Resident',
                style: TextStyle(
                  color: const Color(0xFF6A624F),
                  fontSize: 14.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            const PreferencesSection(),
            SizedBox(height: 24.h),
            PrivacySection(
              showProfileToPublic: _showProfileToPublic,
              onToggle: (val) => setState(() => _showProfileToPublic = val),
            ),
            SizedBox(height: 24.h),
            SplitBillSection(
              electricitySplit: _electricitySplit,
              waterSplit: _waterSplit,
              onElectricityToggle: (val) =>
                  setState(() => _electricitySplit = val),
              onWaterToggle: (val) => setState(() => _waterSplit = val),
            ),
            SizedBox(height: 32.h),
            Text(
              'App Version 2.4.0',
              style: TextStyle(
                color: const Color(0xFF4C463C).withValues(alpha: 0.5),
                fontSize: 12.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 64.h),
          ],
        ),
      ),
    );
  }
}
