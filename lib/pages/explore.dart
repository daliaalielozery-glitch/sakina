import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/listings/bloc/listings_bloc.dart';
import 'package:sakina/features/listings/bloc/listings_event.dart';
import 'package:sakina/features/listings/repository/listings_repository.dart';
import 'package:sakina/pages/widgets/property_list.dart';
import 'package:sakina/features/map/screens/map_screen.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  late ListingsBloc _listingsBloc;

  @override
  void initState() {
    super.initState();
    _listingsBloc = ListingsBloc(ListingsRepository())..add(LoadListings());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _listingsBloc,
      child: Scaffold(
        appBar: const Myappbar(),
        backgroundColor: AppColors.primaryColor,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover\nyour new house!',
                  style: TextStyle(
                    color: Color(0xFF120A00),
                    fontSize: 30,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 24),

                // Search bar + filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SearchBar(
                        controller: _searchController,
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.search),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hintText: 'Search by area, title...',
                        onChanged: (value) {
                          if (value.length > 2) {
                            _listingsBloc.add(SearchListings(value));
                          } else if (value.isEmpty) {
                            _listingsBloc.add(LoadListings());
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
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
                        _showFilterSheet(context);
                      },
                      icon: SvgPicture.asset("assets/icons/filtericon.svg"),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Map section
                _buildMapSection(context),

                const SizedBox(height: 24),

                // Listings
                const PropertyListingScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Browse by Area',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.4,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to full map screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapSearchScreen(),
                  ),
                );
              },
              child: const Text(
                'View Map',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888880),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Mini map preview — tap to open full map
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapSearchScreen(),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: _MiniMapPainter(),
                    size: const Size(double.infinity, 180),
                    child: const SizedBox.expand(),
                  ),
                  const Positioned(
                    top: 52,
                    left: 68,
                    child: _MapPin(label: 'Maadi', isDark: true),
                  ),
                  const Positioned(
                    top: 108,
                    left: 152,
                    child: _MapPin(label: 'Zamalek', isDark: false),
                  ),
                  // Tap overlay hint
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map_outlined,
                              color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Open Map',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    String selectedType = 'All';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: ['All', 'apartment', 'room', 'studio'].map((type) {
                  final isSelected = selectedType == type;
                  return GestureDetector(
                    onTap: () {
                      setModalState(() => selectedType = type);
                      if (type == 'All') {
                        _listingsBloc.add(LoadListings());
                      } else {
                        _listingsBloc.add(LoadListingsByType(type));
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFFF2F0EB),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        type[0].toUpperCase() + type.substring(1),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Mini map painter
class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final W = size.width;
    final H = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, W, H),
      Paint()..color = const Color(0xFFDDD9CF),
    );

    final block = Paint()..color = const Color(0xFFC8C4B8);

    void drawBlock(double x, double y, double w, double h) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, w, h), const Radius.circular(3)),
        block,
      );
    }

    drawBlock(W * 0.01, H * 0.03, W * 0.17, H * 0.25);
    drawBlock(W * 0.22, H * 0.03, W * 0.14, H * 0.23);
    drawBlock(W * 0.40, H * 0.02, W * 0.18, H * 0.26);
    drawBlock(W * 0.62, H * 0.03, W * 0.15, H * 0.24);
    drawBlock(W * 0.81, H * 0.02, W * 0.18, H * 0.26);
    drawBlock(W * 0.01, H * 0.36, W * 0.12, H * 0.27);
    drawBlock(W * 0.16, H * 0.35, W * 0.19, H * 0.26);
    drawBlock(W * 0.40, H * 0.36, W * 0.16, H * 0.27);
    drawBlock(W * 0.62, H * 0.35, W * 0.14, H * 0.28);
    drawBlock(W * 0.81, H * 0.36, W * 0.18, H * 0.27);

    final road = Paint()
      ..color = const Color(0xFFECE8DF)
      ..strokeWidth = W * 0.012
      ..style = PaintingStyle.stroke;

    for (final y in [0.31, 0.65]) {
      canvas.drawLine(Offset(0, H * y), Offset(W, H * y), road);
    }
    for (final x in [0.14, 0.38, 0.60, 0.80]) {
      canvas.drawLine(Offset(W * x, 0), Offset(W * x, H), road);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MapPin extends StatelessWidget {
  final String label;
  final bool isDark;
  const _MapPin({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on,
              size: 13, color: isDark ? Colors.white : const Color(0xFF1C1C1C)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1C1C1C),
              fontFamily: 'Manrope',
            ),
          ),
        ],
      ),
    );
  }
}
