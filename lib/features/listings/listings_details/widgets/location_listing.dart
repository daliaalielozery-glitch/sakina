
import 'dart:ui' as ui;
 
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


// ── Location Map Widget ────────────────────────────────────────────────────────
class LocationMapWidget extends StatelessWidget {
  const LocationMapWidget({super.key});
 
  // Zamalek, Cairo coordinates
  static const LatLng _listingLocation = LatLng(30.0626, 31.2197);
 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(25),
        width: 360,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBE0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section Title ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0 ),
              child: Text(
                'Location',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
            ),
       
            // ── Map ──
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _listingLocation,
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    // OpenStreetMap tile layer (no API key required)
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.listing',
                    ),
                    // Listing pin marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _listingLocation,
                          width: 48,
                          height: 56,
                          child: const _ListingPin(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
 
// ── Custom pin shape ───────────────────────────────────────────────────────────
class _ListingPin extends StatelessWidget {
  const _ListingPin();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.home_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        // Pin tail triangle
        CustomPaint(
          size: const Size(12, 8),
          painter: _PinTailPainter(),
        ),
      ],
    );
  }
}
 
class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}