import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/ai_match/screens/loading_screen.dart';
import 'package:sakina/features/home/bloc/home_bloc.dart';
import 'package:sakina/pages/explore.dart';
import 'package:sakina/pages/favourite.dart';
import 'package:sakina/pages/messages.dart';
import 'package:sakina/pages/widgets/services_near_you.dart';
import 'package:sakina/pages/widgets/top_match.dart';

// ─── Entry point screen (replaces ButtomNavBarScreen) ────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: activeindex == 0 ? const Myappbar() : null,
      backgroundColor: AppColors.primaryColor,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: AppColors.bottomNavigationBarColor,
          borderRadius: const BorderRadius.only(
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
              icon: Icon(
                Icons.home,
                color: activeindex == 0 ? AppColors.themeColor : Colors.white,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                color: activeindex == 1 ? AppColors.themeColor : Colors.white,
              ),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: activeindex == 2 ? AppColors.themeColor : Colors.white,
              ),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                color: activeindex == 3 ? AppColors.themeColor : Colors.white,
              ),
              label: "Messages",
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _buildScreen(),
      ),
    );
  }

  Widget _buildScreen() {
    switch (activeindex) {
      case 0:
        return BlocProvider(
          create: (context) => HomeBloc(),
          child: const _HomeContent(),
        );
      case 1:
        return const ExplorePage();
      case 2:
        return const FavouritePage();
      case 3:
        return const MessagesPage();
      default:
        return const _HomeContent();
    }
  }
}

// ─── Home tab content ─────────────────────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Hero Text ──────────────────────────────────────────
            Text(
              'Find your quiet in the chaos.',
              style: TextStyle(
                color: const Color(0xFF120A00),
                fontSize: 32,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                letterSpacing: -1.60,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Curated roommate matches and premium living spaces across Egypt's academic districts.",
              style: TextStyle(
                color: const Color(0xFF4C463C),
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24, width: 24),

            // ─── Search Bar + Filter ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SearchBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: const Icon(Icons.search),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    hintText: 'Search by area or university...',
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 24, height: 24),
                IconButton(
                  padding: const EdgeInsets.all(20),
                  style: IconButton.styleFrom(
                    iconSize: 20,
                    backgroundColor: AppColors.bottomNavigationBarColor,
                    foregroundColor: AppColors.appbarColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/filtericon.svg"),
                ),
              ],
            ),

            // ─── AI Smart Match Card ─────────────────────────────────
            SizedBox(height: 24, width: 24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBeig,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/pictures/AI_Cute.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: const Text(
                            'AI Smart Match',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Manrope',
                              color: Color(0xFF4D4634),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Text(
                          'Let AI find your perfect room.',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF120A00),
                            height: 1.80,
                            letterSpacing: -1.60,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: const Text(
                            'Personalized matches tailored to your lifestyle and budget.',
                            style: TextStyle(
                              color: Color(0xFF4C463C),
                              fontSize: 16,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 12.0,
                          ),
                          child: SizedBox(
                            width: 170,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoadingScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bottomNavigationBarColor,
                                foregroundColor: AppColors.primaryBeig,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Find my match',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  height: 1.71,
                                  letterSpacing: 0.40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Browse Nearby ───────────────────────────────────────
            SizedBox(height: 24, width: 24),
            Container(
              color: AppColors.themeColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Browse Nearby',
                        style: TextStyle(
                          color: Color(0xFF120A00),
                          fontSize: 24,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                          letterSpacing: -0.60,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'VIEW MAP',
                          style: TextStyle(
                            color: const Color(0xFF4C463C),
                            fontSize: 12,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: 1.20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: 190.38,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/pictures/room.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0, -0.5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1C),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    '98% Match',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/pictures/room.jpg',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Premium Studio, Maadi',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1C1C1C),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 14,
                                                color: Color(0xFF888888),
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                '0.8km away',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFF888888),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF1C1C1C),
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Top Match ───────────────────────────────────────────
            TopMatch(),
            SizedBox(height: 24, width: 24),

            // ─── Services Near You ───────────────────────────────────
            ServicesNearYouContainer(),
          ],
        ),
      ),
    );
  }
}