import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Myappbar(),
      backgroundColor: AppColors.primaryColor,
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    hintText: 'Search by area or university...',
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
            //------------------start----------------container for AI smart match----------------------------------

            

            SizedBox(height: 24, width: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryBeig,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Robot icon with sparkles
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Robot emoji or image
                        Center(
                          child: Image.asset(
                            'assets/pictures/AI_Cute.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text content + button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        // Label
                        const Text(
                          'AI Smart Match',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Manrope',
                            color: Color(0xFF4D4634),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Bold headline
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

                        const SizedBox(height: 6),

                        // Subtext
                        const Text(
                          'Personalized matches tailored\n to your lifestyle and budget.',
                          style: TextStyle(
                            color: Color(0xFF4C463C),
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            height: 1.63,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // CTA Button
                        SizedBox(
                          
                          width: 170,
                          height: 35,
                          child: ElevatedButton(
                            // ------------------------on pressed button of AI smart match is here------------------------
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.bottomNavigationBarColor,
                              foregroundColor: AppColors.primaryBeig,
                              // padding: const EdgeInsets.symmetric(vertical: 8),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //------------------end----------------container for AI smart match----------------------------------


            
          ],
        ),
      ),
    );
  }
}
