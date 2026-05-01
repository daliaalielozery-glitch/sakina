import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/profiles/ui/widgets/match_percentage_widget.dart';

class RoomateProfileCard extends StatelessWidget {
  final String imageUrl;
  final String profession;
  final String userName;
  final String university;
  final String? matchPercentage; 
  const RoomateProfileCard({
    super.key,
    required this.imageUrl,
    required this.profession,
    required this.userName,
    required this.university,
    this.matchPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Image Container-------------------------------------------
        Container(
          width: double.infinity,
          height: 500.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient and Info Overlay------------------------------
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF120A00).withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profession Label------------------------------
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E0B6),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      child: Text(
                        profession.toUpperCase(),
                        style: TextStyle(
                          color: const Color(0xFF251A02),
                          fontSize: 10.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // User Name------------------------------
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // University------------------------------
                    Text(
                      university,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Match Percentage appear if i call it
              if (matchPercentage != null)
                MatchPercentageWidget(percentage: matchPercentage!),
            ],
          ),
        ),
      ],
    );
  }
}