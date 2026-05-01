import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';

class ListingAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ListingAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () => print('Share'),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => print('Favorite'),
          ),
          const SizedBox(width: 16),
        ],
      );
  }
}