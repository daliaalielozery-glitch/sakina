import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsServiceItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? tag;

  const DetailsServiceItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEAE8E5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9F6),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(icon, color: const Color(0xFF120A00), size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: const Color(0xFF120A00), fontSize: 16.sp, fontWeight: FontWeight.w700)),
                Text(description, style: TextStyle(color: const Color(0xFF4C463C), fontSize: 12.sp)),
              ],
            ),
          ),
          if (tag != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(109, 92, 59, 0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Text(tag!, style: TextStyle(color: const Color(0xFF6D5C3B), fontSize: 10.sp)),
            )
          else
            Icon(Icons.arrow_forward_ios, color: const Color(0xFFCFC5B8), size: 16.sp),
        ],
      ),
    );
  }
}