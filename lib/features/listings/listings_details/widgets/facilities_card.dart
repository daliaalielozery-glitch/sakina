import 'package:flutter/material.dart';
import 'package:sakina/features/listings/models/listing_model.dart';

class FacilitiesCard extends StatelessWidget {
  final ListingModel listing;

  const FacilitiesCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    final facilities = listing.publicFacilities
        .map(
          (facility) => _DetailItem(
            icon: _iconForPlace(facility),
            label: facility.name,
            subtitle: facility.subtitle,
          ),
        )
        .toList();

    final essentials = listing.nearbyServices
        .map(
          (service) => _DetailItem(
            icon: _iconForPlace(service),
            label: service.name,
            subtitle: service.subtitle,
          ),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Public Facilities'),
          const SizedBox(height: 16),
          _DetailGrid(
            items: facilities,
            emptyText:
                'No public facilities have been added near this listing yet.',
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFD8D0C0), thickness: 1),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Nearby Essentials'),
          const SizedBox(height: 16),
          _DetailGrid(
            items: essentials,
            emptyText:
                'Nearby services will appear here when they are linked to this listing.',
          ),
        ],
      ),
    );
  }

  IconData _iconForPlace(ListingPlace place) {
    final text = '${place.category ?? ''} ${place.name}'.toLowerCase();
    if (text.contains('laundry')) return Icons.local_laundry_service_outlined;
    if (text.contains('food') ||
        text.contains('restaurant') ||
        text.contains('kitchen')) {
      return Icons.restaurant_outlined;
    }
    if (text.contains('maintenance') || text.contains('repair')) {
      return Icons.handyman_outlined;
    }
    if (text.contains('market') || text.contains('grocery')) {
      return Icons.shopping_cart_outlined;
    }
    if (text.contains('pharmacy') || text.contains('hospital')) {
      return Icons.local_hospital_outlined;
    }
    if (text.contains('metro') || text.contains('bus')) {
      return Icons.directions_bus_outlined;
    }
    if (text.contains('gym') || text.contains('club')) {
      return Icons.fitness_center_outlined;
    }
    if (text.contains('university') || text.contains('school')) {
      return Icons.school_outlined;
    }
    return Icons.place_outlined;
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

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

class _DetailGrid extends StatelessWidget {
  final List<_DetailItem> items;
  final String emptyText;

  const _DetailGrid({
    required this.items,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        emptyText,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF7A7060),
          height: 1.4,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth >= 370
            ? constraints.maxWidth / 2
            : constraints.maxWidth;

        return Wrap(
          runSpacing: 20,
          children: items
              .map(
                (item) => SizedBox(
                  width: itemWidth,
                  child: item,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;

  const _DetailItem({
    required this.icon,
    required this.label,
    this.subtitle,
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
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  height: 1.35,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A7060),
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class EssentialComfortsCard extends StatelessWidget {
  final ListingModel listing;

  const EssentialComfortsCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    final comforts = listing.amenities.isNotEmpty
        ? listing.amenities
            .map(
              (amenity) => _DetailItem(
                icon: _iconForAmenity(amenity),
                label: amenity,
              ),
            )
            .toList()
        : <_DetailItem>[
            const _DetailItem(
              icon: Icons.verified_outlined,
              label: 'Verified listing',
            ),
            _DetailItem(
              icon: Icons.photo_outlined,
              label: listing.coverImage == null
                  ? 'Photos coming soon'
                  : 'Primary photo available',
            ),
          ];

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Essential Comforts'),
          const SizedBox(height: 16),
          _DetailGrid(
            items: comforts,
            emptyText:
                'Essential comforts will appear here when the host adds amenities.',
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFD8D0C0), thickness: 1),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  IconData _iconForAmenity(String amenity) {
    final normalized = amenity.toLowerCase();
    if (normalized.contains('wi')) return Icons.wifi;
    if (normalized.contains('ac')) return Icons.ac_unit;
    if (normalized.contains('laundry')) {
      return Icons.local_laundry_service_outlined;
    }
    if (normalized.contains('parking')) return Icons.local_parking_outlined;
    if (normalized.contains('clean')) return Icons.cleaning_services_outlined;
    if (normalized.contains('furnish')) return Icons.chair_outlined;
    return Icons.check_circle_outline;
  }
}
