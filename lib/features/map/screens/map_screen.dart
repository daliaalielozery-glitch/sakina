import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────
class PropertyPin {
  final LatLng position;
  final int priceEGP;
  final String title;
  final String district;
  final String propertyType;
  final int rooms;
  final String imageUrl;
  final List<String> tags;

  const PropertyPin({
    required this.position,
    required this.priceEGP,
    required this.title,
    required this.district,
    required this.propertyType,
    required this.rooms,
    required this.imageUrl,
    this.tags = const [],
  });
}

// ─── Sample Data — Cairo's academic districts ─────────────────────────────
const List<PropertyPin> _properties = [
  PropertyPin(
    position: LatLng(30.0131, 31.2089),
    priceEGP: 8500,
    title: 'Zamalek Garden Studio',
    district: 'Zamalek, Cairo',
    propertyType: 'Studio',
    rooms: 1,
    imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600',
    tags: ['Furnished', 'Wi-Fi', 'AC'],
  ),
  PropertyPin(
    position: LatLng(30.0061, 31.2001),
    priceEGP: 6200,
    title: 'Agouza Quiet Room',
    district: 'Agouza, Giza',
    propertyType: 'Room',
    rooms: 1,
    imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600',
    tags: ['Quiet', 'Near Metro'],
  ),
  PropertyPin(
    position: LatLng(29.9792, 31.1342),
    priceEGP: 11000,
    title: 'Maadi Premium Apartment',
    district: 'Maadi, Cairo',
    propertyType: 'Apartment',
    rooms: 2,
    imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600',
    tags: ['Furnished', 'Parking', 'Garden'],
  ),
  PropertyPin(
    position: LatLng(30.0594, 31.2227),
    priceEGP: 7800,
    title: 'Heliopolis Heritage Flat',
    district: 'Heliopolis, Cairo',
    propertyType: 'Apartment',
    rooms: 2,
    imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=600',
    tags: ['Spacious', 'AC', 'Wi-Fi'],
  ),
  PropertyPin(
    position: LatLng(30.0220, 31.2357),
    priceEGP: 5500,
    title: 'Downtown Budget Studio',
    district: 'Downtown, Cairo',
    propertyType: 'Studio',
    rooms: 1,
    imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=600',
    tags: ['Budget', 'Central Location'],
  ),
  PropertyPin(
    position: LatLng(30.0071, 31.2156),
    priceEGP: 9200,
    title: 'Dokki Spacious Loft',
    district: 'Dokki, Giza',
    propertyType: 'Apartment',
    rooms: 3,
    imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600',
    tags: ['Furnished', 'Balcony', 'Near Cairo Uni'],
  ),
  PropertyPin(
    position: LatLng(29.9868, 31.1563),
    priceEGP: 14500,
    title: 'New Cairo Luxury Suite',
    district: 'New Cairo, Cairo',
    propertyType: 'Apartment',
    rooms: 2,
    imageUrl: 'https://images.unsplash.com/photo-1531835551805-16d864c8d311?w=600',
    tags: ['Luxury', 'Pool', 'Gym'],
  ),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────
class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  static const LatLng _cairoCenter = LatLng(30.0131, 31.2089);
  static const double _initialZoom = 13.5;

  int? _selectedIndex;
  late AnimationController _sheetController;
  late Animation<Offset> _sheetAnimation;
  List<PropertyPin> _filteredProperties = _properties;
  String _searchQuery = '';

  final List<_Category> _categories = const [
    _Category(icon: Icons.bed_outlined, label: 'Rooms'),
    _Category(icon: Icons.apartment, label: 'Apartments'),
    _Category(icon: Icons.villa_outlined, label: 'Studios'),
  ];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      duration: const Duration(milliseconds: 320),
      vsync: this,
    );
    _sheetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _sheetController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      _selectedIndex = null;

      if (_searchQuery.isEmpty) {
        _filteredProperties = _properties;
        _mapController.move(_cairoCenter, _initialZoom);
      } else {
        _filteredProperties = _properties.where((p) {
          return p.title.toLowerCase().contains(_searchQuery) ||
              p.district.toLowerCase().contains(_searchQuery) ||
              p.propertyType.toLowerCase().contains(_searchQuery);
        }).toList();

        if (_filteredProperties.isNotEmpty) {
          _mapController.move(
            _filteredProperties.first.position,
            14.5,
          );
        }
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearch('');
  }

  String _formatPrice(int price) => price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  void _selectPin(int index) {
    setState(() => _selectedIndex = index);
    _sheetController.forward(from: 0);
    final pos = _filteredProperties[index].position;
    _mapController.move(
      LatLng(pos.latitude - 0.012, pos.longitude),
      _initialZoom,
    );
  }

  void _dismissCard() {
    _sheetController.reverse().then((_) {
      if (mounted) setState(() => _selectedIndex = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: Stack(
        children: [
          // ── Map ────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _cairoCenter,
              initialZoom: _initialZoom,
              minZoom: 10,
              maxZoom: 18,
              onTap: (_, __) => _dismissCard(),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.sakina.app',
              ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < _filteredProperties.length; i++)
                    Marker(
                      point: _filteredProperties[i].position,
                      width: 110,
                      height: 44,
                      child: GestureDetector(
                        onTap: () => _selectPin(i),
                        child: _PriceBadge(
                          price: _filteredProperties[i].priceEGP,
                          isSelected: i == _selectedIndex,
                          formatPrice: _formatPrice,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // ── Top overlay ────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFFF4EFE9),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SearchBar(
                      controller: _searchController,
                      onChanged: _onSearch,
                      onClear: _clearSearch,
                      query: _searchQuery,
                    ),
                    const SizedBox(height: 8),
                    _CategoryRow(
                      categories: _categories,
                      selected: _selectedCategory,
                      onTap: (i) =>
                          setState(() => _selectedCategory = i),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── My Location FAB ────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 158,
            right: 12,
            child: _MapFab(
              icon: Icons.my_location,
              onTap: () =>
                  _mapController.move(_cairoCenter, _initialZoom),
            ),
          ),

          // ── Property Detail Card ───────────────────────────────────────
          if (_selectedIndex != null)
            Positioned(
              bottom: 80,
              left: 12,
              right: 12,
              child: SlideTransition(
                position: _sheetAnimation,
                child: _PropertyCard(
                  property: _filteredProperties[_selectedIndex!],
                  formatPrice: _formatPrice,
                  onClose: _dismissCard,
                  onViewDetails: () => _dismissCard(),
                ),
              ),
            ),

          // ── No results message ─────────────────────────────────────────
          if (_filteredProperties.isEmpty && _searchQuery.isNotEmpty)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_off,
                        color: Color(0xFF888888)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No properties found for "$_searchQuery"',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          color: Color(0xFF4C463C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Bottom List button ─────────────────────────────────────────
          if (_selectedIndex == null && _filteredProperties.isNotEmpty)
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: _ListButton(
                  count: _filteredProperties.length,
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
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5EFE6),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      '${_filteredProperties.length} properties'
                      '${_searchQuery.isNotEmpty ? ' for "$_searchQuery"' : ' nearby'}',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF120A00),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredProperties.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final p = _filteredProperties[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _selectPin(i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                              child: Image.network(
                                p.imageUrl,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(
                                  width: 90,
                                  height: 90,
                                  color: const Color(0xFFE0D8CC),
                                  child: const Icon(Icons.home,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 4),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(p.title,
                                        style: const TextStyle(
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xFF120A00),
                                        )),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      const Icon(
                                          Icons.location_on_outlined,
                                          size: 12,
                                          color: Color(0xFF888888)),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(p.district,
                                            style: const TextStyle(
                                              fontFamily: 'Manrope',
                                              fontSize: 12,
                                              color: Color(0xFF888888),
                                            ),
                                            overflow:
                                                TextOverflow.ellipsis),
                                      ),
                                    ]),
                                    const SizedBox(height: 6),
                                    Text(
                                        'EGP ${_formatPrice(p.priceEGP)} / mo',
                                        style: const TextStyle(
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xFF1C1C1C),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.chevron_right,
                                  color: Color(0xFF888888)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Property Detail Card ────────────────────────────────────────────────────
class _PropertyCard extends StatelessWidget {
  final PropertyPin property;
  final String Function(int) formatPrice;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;

  const _PropertyCard({
    required this.property,
    required this.formatPrice,
    required this.onClose,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5EFE6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.18),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24)),
                  child: Image.network(
                    property.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: const Color(0xFFE0D8CC),
                      child: const Center(
                          child:
                              Icon(Icons.home, size: 48, color: Colors.grey)),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.12),
                              blurRadius: 6)
                        ],
                      ),
                      child: const Icon(Icons.close,
                          size: 18, color: Color(0xFF1C1C1C)),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      property.propertyType.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(property.title,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF120A00),
                                )),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: Color(0xFF888888)),
                              const SizedBox(width: 2),
                              Text(property.district,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 13,
                                    color: Color(0xFF888888),
                                  )),
                            ]),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('EGP ${formatPrice(property.priceEGP)}',
                              style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF120A00),
                              )),
                          const Text('/ month',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                color: Color(0xFF888888),
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: property.tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE8E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(tag,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 12,
                                    color: Color(0xFF4C463C),
                                    fontWeight: FontWeight.w500,
                                  )),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onViewDetails,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1C),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: const Text('View Details',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE8E0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.favorite_border,
                            color: Color(0xFF1C1C1C), size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String query;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: 6,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.12),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 22, color: Colors.black87),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by area, district or type…',
                    hintStyle: TextStyle(
                      fontFamily: 'Manrope',
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (query.isNotEmpty)
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 14, color: Colors.black54),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune,
                      size: 18, color: Colors.black87),
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
      height: 66,
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
                  Icon(cat.icon,
                      size: 26,
                      color:
                          isSelected ? Colors.black : Colors.black45),
                  const SizedBox(height: 5),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color:
                          isSelected ? Colors.black : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 2,
                    width: 28,
                    color: isSelected
                        ? Colors.black
                        : Colors.transparent,
                  ),
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.14),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF1C1C1C)),
      ),
    );
  }
}

// ─── List Button ─────────────────────────────────────────────────────────────
class _ListButton extends StatelessWidget {
  final VoidCallback onTap;
  final int count;
  const _ListButton({required this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.22),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.list, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Show $count listing${count == 1 ? '' : 's'}',
              style: const TextStyle(
                fontFamily: 'Manrope',
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Price Badge ─────────────────────────────────────────────────────────────
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1C1C1C)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF1C1C1C)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color.fromRGBO(28, 28, 28, 0.30)
                : const Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: isSelected ? 10 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'EGP ${formatPrice(price)}',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : const Color(0xFF1C1C1C),
        ),
      ),
    );
  }
}