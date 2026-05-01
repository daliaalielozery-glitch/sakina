import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/compatibility_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/custom_action_btn.dart';
import 'package:sakina/features/profiles/ui/widgets/lifestyle_habit_item.dart';
import 'package:sakina/features/profiles/ui/widgets/roomate_profile_card.dart';

class RoommateRequestScreen extends StatelessWidget {
  const RoommateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const Myappbar(
        showProfile: true,
        title: 'Sakina',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            // Profile Card Image Section
            SizedBox(height: 24.h),

            // Persona & Action Buttons
            RoomateProfileCard(
              imageUrl:
                  'https://w0.peakpx.com/wallpaper/828/935/HD-wallpaper-lisa-blackpink-singer-celebrity.jpg',
              profession: 'Doctor',
              userName: 'Lisa',
              university: 'Must\n Giza',
              matchPercentage: '75%',
            ),
            SizedBox(height: 24.h),

            // Compatibility Section------------------------------
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEADEC6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMPATIBILITY',
                    style: TextStyle(
                      color: const Color(0xFF6A624F),
                      fontSize: 10.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const CompatibilityBar(label: 'Cleanliness', progress: 0.95),
                  SizedBox(height: 12.h),
                  const CompatibilityBar(label: 'Social Style', progress: 0.8),
                  SizedBox(height: 12.h),
                  const CompatibilityBar(label: 'Sleep Cycle', progress: 0.9),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Lifestyle & Habits Section (GridView)------------------------------
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 2.5,
              children: const [
                LifestyleHabitItem(icon: Icons.volume_off, label: 'Quiet'),
                LifestyleHabitItem(
                    icon: Icons.wb_sunny_outlined, label: 'Early Bird'),
                LifestyleHabitItem(icon: Icons.smoke_free, label: 'Non-smoker'),
                LifestyleHabitItem(
                    icon: Icons.cleaning_services_outlined,
                    label: 'Cleanliness',
                    subtitle: 'High'),
              ],
            ),
            SizedBox(height: 24.h),

            // Bottom Action Buttons------------------------------
            Row(
              children: [
                Expanded(
                  child: CustomActionBtn(
                    text: 'accept request',
                    backgroundColor: const Color(0xFF54A159),
                    textColor: const Color(0xFF171001),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: CustomActionBtn(
                    text: 'decline request',
                    backgroundColor: const Color(0xFF330303),
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
