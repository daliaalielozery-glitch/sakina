import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Facilities',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Georgia',
//         scaffoldBackgroundColor: const Color(0xFFF5F0E8),
//       ),
//       home: const Scaffold(
//         body: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(24),
//             child: FacilitiesCard(),
//           ),
//         ),
//       ),
//     );
//   }
// }

class FacilitiesCard extends StatelessWidget {
  const FacilitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Public Facilities ──
            const SectionTitle(title: 'Public Facilities'),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: FacilityItem(
                    icon: Icons.stadium_outlined,
                    label: 'Al-Ahly\nClub',
                  ),
                ),
                Expanded(
                  child: FacilityItem(
                    icon: Icons.subway_outlined,
                    label: 'Opera\nMetro',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: FacilityItem(
                    icon: Icons.restaurant_outlined,
                    label: 'Food\nDistrict',
                  ),
                ),
                Expanded(
                  child: FacilityItem(
                    icon: Icons.school_outlined,
                    label: 'AUC Tahrir',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: FacilityItem(
                    icon: Icons.directions_bus_outlined,
                    label: 'Bus\nTerminal',
                  ),
                ),
                Expanded(
                  child: FacilityItem(
                    icon: Icons.local_hospital_outlined,
                    label: 'El Nile Hospital',
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 32),
            const Divider(color: Color(0xFFD8D0C0), thickness: 1),
            const SizedBox(height: 24),
      
            // ── Nearby Essentials ──
            const SectionTitle(title: 'Nearby Essentials'),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: EssentialItem(
                    icon: Icons.local_laundry_service_outlined,
                    name: 'QuickWash\nZamalek',
                    distance: '300m away',
                  ),
                ),
                Expanded(
                  child: EssentialItem(
                    icon: Icons.restaurant_outlined,
                    name: 'Zamalek Food\nCourt',
                    distance: '500m away',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: EssentialItem(
                    icon: Icons.shopping_cart_outlined,
                    name: 'Seoudi Market',
                    distance: '400m away',
                  ),
                ),
                Expanded(
                  child: EssentialItem(
                    icon: Icons.medical_services_outlined,
                    name: 'El Ezaby\nPharmacy',
                    distance: '200m away',
                  ),
                ),
              ],
            ),
          ],
        ),
    );
    
  }
}

// ── Section Title ──────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
        letterSpacing: -0.5,
        height: 1.1,
      ),
    );
  }
}

// ── Public Facility Item ───────────────────────────────────────────────────────
class FacilityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const FacilityItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            icon,
            size: 24,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Nearby Essential Item ──────────────────────────────────────────────────────
class EssentialItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String distance;

  const EssentialItem({
    super.key,
    required this.icon,
    required this.name,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            icon,
            size: 24,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7A7060),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class EssentialComfortsCard extends StatelessWidget {
  const EssentialComfortsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Essential Comforts ──
            const SectionTitle(title: 'Essential Comforts'),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: ComfortsItem(
                    icon: Icons.wifi,
                    label: 'Giga-Fiber Wi-Fi',
                  ),
                ),
                Expanded(
                  child: ComfortsItem(
                    icon: Icons.ac_unit,
                    label: 'Central AC',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: ComfortsItem(
                    icon: Icons.local_laundry_service,
                    label: 'In-unit Laundry',
                  ),
                ),
                Expanded(
                  child: ComfortsItem(
                    icon: Icons.shield_outlined,
                    label: 'Biometric Entry',
                  ),
                ),
              ],
            ),

      
            const SizedBox(height: 32),
            const Divider(color: Color(0xFFD8D0C0), thickness: 1),
            const SizedBox(height: 24),
      
          ],
        ),
    );
    
  }
}

// ── Essential Comforts Item ───────────────────────────────────────────────────────
class  ComfortsItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const  ComfortsItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            icon,
            size: 24,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

