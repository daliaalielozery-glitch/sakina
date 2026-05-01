import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsHeroHeader extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String rating;

  const DetailsHeroHeader({
    super.key, 
    required this.imageUrl, 
    required this.title, 
    required this.location, 
    required this.rating
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(imageUrl, width: 1.sw, height: 397.h, fit: BoxFit.cover),
        Container(
          width: 1.sw,
          height: 397.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color.fromRGBO(18, 10, 0, 0.6), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          left: 32.w,
          bottom: 30.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBadge(),
              SizedBox(height: 8.h),
              Text(title, style: TextStyle(color: const Color(0xFFFBF9F6), fontSize: 32.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.star, color: const Color(0xFFF7E0B6), size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(rating, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                  SizedBox(width: 8.w),
                  Text('• $location', style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(color: const Color(0xFFF7E0B6), borderRadius: BorderRadius.circular(2.r)),
      child: Text('FEATURED PARTNER', style: TextStyle(color: const Color(0xFF251A02), fontSize: 10.sp, fontWeight: FontWeight.w700)),
    );
  }
}