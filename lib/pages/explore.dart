import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/pages/widgets/browse_by_area.dart';
import 'package:sakina/pages/widgets/property_list.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Myappbar(),
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover\nyour new house!',
                style: TextStyle(
                  color: const Color(0xFF120A00),
                  fontSize: 30,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),

              SizedBox(height: 24, width: 24),
              //------------------start----------------search bar and filter button----------------------------------
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
                      hintText: 'Search Places',
                      onChanged: (value) {
                        // Handle search input changes
                      },
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
                    onPressed: () {
                      // Handle filter button press
                    },
                    icon: SvgPicture.asset("assets/icons/filtericon.svg"),
                  ),
                ],
              ),

              //------------------end----------------search bar and filter button----------------------------------
              SizedBox(height: 24, width: 24),

              BrowseByAreaWidget(),

              SizedBox(height: 24, width: 24),

              PropertyListingScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
