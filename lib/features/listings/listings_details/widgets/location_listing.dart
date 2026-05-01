import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sakina/features/listings/models/listing_model.dart';

class LocationMapWidget extends StatelessWidget {
  final ListingModel listing;

  const LocationMapWidget({
    super.key,
    required this.listing,
  });

  static const LatLng _fallbackLocation = LatLng(30.0444, 31.2357);

  LatLng get _listingLocation {
    final latitude = listing.latitude;
    final longitude = listing.longitude;
    if (latitude == null || longitude == null) return _fallbackLocation;
    return LatLng(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    final locationText = listing.address?.isNotEmpty == true
        ? listing.address!
        : listing.locationDisplay;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(25),
        width: 360,
        decoration: BoxDecoration(
          color: const Color(0xFFF0EBE0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  if (locationText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      locationText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4C463C),
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _listingLocation,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.sakina.app',
                    ),
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
