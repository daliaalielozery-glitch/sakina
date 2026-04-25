import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────
class PricedLocation {
  final LatLng position;
  final int priceEGP;
  final String title;

  const PricedLocation({
    required this.position,
    required this.priceEGP,
    required this.title,
  });
}

// ─── Sample Data (around Alexanderplatz, Berlin) ─────────────────────────────
const List<PricedLocation> _locations = [
  PricedLocation(position: LatLng(52.526, 13.411), priceEGP: 1618, title: 'Studio near Memhard'),
  PricedLocation(position: LatLng(52.523, 13.416), priceEGP: 2156, title: 'Modern flat'),
  PricedLocation(position: LatLng(52.521, 13.405), priceEGP: 1020, title: 'Cozy apartment'),
  PricedLocation(position: LatLng(52.520, 13.413), priceEGP: 1705, title: 'Central room'),
  PricedLocation(position: LatLng(52.518, 13.425), priceEGP: 3595, title: 'Luxury suite'),
  PricedLocation(position: LatLng(52.519, 13.403), priceEGP: 1667, title: 'Budget pick'),
  PricedLocation(position: LatLng(52.516, 13.408), priceEGP: 2650, title: 'Spacious loft'),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────
class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final MapController _mapController = MapController();
  int? _selectedIndex;

  // Category tabs (matches Airbnb top bar)
  final List<_Category> _categories = const [
    // _Category(icon: Icons.home_outlined, label: 'Rooms'),
    _Category(icon: Icons.bed_outlined, label: 'Rooms'),
    // _Category(icon: Icons.landscape_outlined, label: 'Amazing views'),
    _Category(icon: Icons.apartment, label: 'Apartments'),

  ];
  int _selectedCategory = 0;

  String _formatPrice(int price) =>
      price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(52.521, 13.413),
              initialZoom: 14.5,
              onTap: (_, __) => setState(() => _selectedIndex = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.sakina.app',
              ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < _locations.length; i++)
                    Marker(
                      point: _locations[i].position,
                      width: 100, // Make it wide enough to fit the text
                      height: 40,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = i),
                        child: _PriceBadge(
                          price: _locations[i].priceEGP,
                          isSelected: i == _selectedIndex,
                          formatPrice: _formatPrice,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // ── Top overlay ──────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFFF4EFE9), // Beige from image
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search bar
                    _SearchBar(),
                    const SizedBox(height: 8),
                    // Category row
                    _CategoryRow(
                      categories: _categories,
                      selected: _selectedCategory,
                      onTap: (i) => setState(() => _selectedCategory = i),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── My Location FAB ──────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 150,
            right: 12,
            child: _MapFab(
              icon: Icons.navigation,
              onTap: () => _mapController.move(const LatLng(52.521, 13.413), 14.5),
            ),
          ),

          // ── Bottom "List" button ─────────────────────────────────────────
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: _ListButton(
                onTap: () => _showListSheet(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showListSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView.separated(
            controller: controller,
            padding: const EdgeInsets.all(16),
            itemCount: _locations.length + 1,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (_, i) {
              if (i == 0) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    '20+ stays',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              }
              final loc = _locations[i - 1];
              return ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.home, color: Colors.grey),
                ),
                title: Text(loc.title),
                subtitle: Text('EGP ${_formatPrice(loc.priceEGP)} / night'),
                trailing: const Icon(Icons.favorite_border),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        elevation: 8,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.15),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 24, color: Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Where to?',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Anywhere · Any week · Add guests',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.tune, size: 20, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Category Row ─────────────────────────────────────────────────────────────
class _Category {
  final IconData icon;
  final String label;
  const _Category({required this.icon, required this.label});
}

class _CategoryRow extends StatelessWidget {
  final List<_Category> categories;
  final int selected;
  final void Function(int) onTap;

  const _CategoryRow({
    required this.categories,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat.icon,
                    size: 28,
                    color: isSelected ? Colors.black : Colors.black54,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.black : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 2,
                    width: 30, // Small line
                    color: isSelected ? Colors.black : Colors.transparent,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Map FAB ─────────────────────────────────────────────────────────────────
class _MapFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapFab({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

// ─── List Button ─────────────────────────────────────────────────────────────
class _ListButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ListButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.22), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.list, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text('Show list', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ─── Price Badge Widget ──────────────────────────────────────────────────────
class _PriceBadge extends StatelessWidget {
  final int price;
  final bool isSelected;
  final String Function(int) formatPrice;

  const _PriceBadge({
    required this.price,
    required this.isSelected,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'EGP ${formatPrice(price)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}