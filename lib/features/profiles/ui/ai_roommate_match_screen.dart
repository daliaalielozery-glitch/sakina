import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/lifestyle_habit_item.dart';
import 'package:sakina/features/profiles/ui/widgets/compatibility_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/custom_action_btn.dart';
import 'package:sakina/features/profiles/ui/widgets/roomate_profile_card.dart';

class AiRoommateMatchScreen extends StatelessWidget {
  const AiRoommateMatchScreen({super.key});

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
            // Profile Card Image Section----------------------
            RoomateProfileCard(
              imageUrl:
                  'https://play-lh.googleusercontent.com/ulMAlLTgPLQwx9gCsQgCp2_YUrOep6Nx_s6BWxQhqwxCPMtVQ9EO37vrw6v8qtwtN3c',
              profession: 'Architect',
              userName: 'Rose',
              university: 'American University in\nCairo',
              matchPercentage: '92%',
            ),
            SizedBox(height: 24.h),
            // Persona Section------------------------------
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3F0),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THE PERSONA',
                    style: TextStyle(
                      color: const Color(0xFF4C463C),
                      fontSize: 10.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '"A third-year architecture student looking for a quiet, organized space. I\'m usually at the studio late, so I value a peaceful environment when I\'m home. Coffee and jazz are my morning staples."',
                    style: TextStyle(
                      color: const Color(0xFF1B1C1A),
                      fontSize: 18.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomActionBtn(
                    text: 'Message Layla',
                    icon: Icons.chat_bubble_outline,
                    backgroundColor: AppColors.primaryBrown,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                  SizedBox(height: 16.h),
                  CustomActionBtn(
                    text: 'View Room Details',
                    icon: Icons.meeting_room_outlined,
                    backgroundColor: const Color(0xFFE4E2DF),
                    textColor: const Color(0xFF1B1C1A),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Compatibility Section-----------------------------------
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lifestyle & Habits',
                        style: TextStyle(
                          color: const Color(0xFF1B1C1A),
                          fontSize: 20.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 48.w,
                        height: 2.h,
                        color: const Color(0xFFF7E0B6),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 2.5,
                    children: const [
                      LifestyleHabitItem(
                          icon: Icons.volume_off, label: 'Quiet'),
                      LifestyleHabitItem(
                          icon: Icons.wb_sunny_outlined, label: 'Early Bird'),
                      LifestyleHabitItem(
                          icon: Icons.smoke_free, label: 'Non-smoker'),
                      LifestyleHabitItem(
                          icon: Icons.cleaning_services_outlined,
                          label: 'Cleanliness',
                          subtitle: 'High'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
