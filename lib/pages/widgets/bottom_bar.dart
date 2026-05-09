import 'package:sakina/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina/features/home/bloc/home_bloc.dart';
import 'package:sakina/pages/explore.dart';
import 'package:sakina/pages/favourite.dart';
import 'package:sakina/pages/home.dart';
import 'package:sakina/pages/messages/chat_screen/messages.dart';

class ButtomNavBarScreen extends StatefulWidget {
  final int initialIndex;
  const ButtomNavBarScreen({super.key, this.initialIndex = 0});

  @override
  State<ButtomNavBarScreen> createState() => _ButtomNavBarScreenState();
}

class _ButtomNavBarScreenState extends State<ButtomNavBarScreen> {
  late int activeindex;

  @override
  void initState() {
    super.initState();
    activeindex = widget.initialIndex;
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return BlocProvider(
          create: (context) => HomeBloc()..add(LoadHomeData()),
          child: const HomeContent(),
        );
      case 1:
        return const ExplorePage();
      case 2:
        return const FavouritePage();
      case 3:
        return const ConversationsScreen();
      default:
        return BlocProvider(
          create: (context) => HomeBloc()..add(LoadHomeData()),
          child: const HomeContent(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: AppColors.bottomNavigationBarColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: BottomNavigationBar(
          backgroundColor: AppColors.bottomNavigationBarColor,
          elevation: 0,
          unselectedItemColor: Colors.white,
          currentIndex: activeindex,
          onTap: (index) => setState(() => activeindex = index),
          selectedItemColor: AppColors.themeColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: activeindex == 0
                      ? AppColors.themeColor
                      : Colors.white),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore,
                  color: activeindex == 1
                      ? AppColors.themeColor
                      : Colors.white),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: activeindex == 2
                      ? AppColors.themeColor
                      : Colors.white),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message,
                  color: activeindex == 3
                      ? AppColors.themeColor
                      : Colors.white),
              label: "Messages",
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: _buildScreen(activeindex),
      ),
    );
  }
}