import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Myappbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showProfile;
  final List<Widget>? actions;

  const Myappbar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showProfile = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] ?? 
                     user?.userMetadata?['name'] ?? 
                     user?.email?.split('@')[0] ?? 
                     'User';


    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.appbarColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                if (showProfile) ...[
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.primaryBeig,
                    backgroundImage: const NetworkImage(
                      'https://thumbs.dreamstime.com/b/avatar-profile-icon-flat-style-female-user-vector-illustration-isolated-background-women-sign-business-concept-321407993.jpg',
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ] else if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
            if (actions != null)
              Row(children: actions!)
            else
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}