import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'location_picker_screen.dart';
import '../utils/universities.dart';
import 'host_profile_screen.dart';
import 'dashboard_screen.dart';

class AppColors {
  static const background = Color(0xFFFAF9F6);
  static const surface = Color(0xFFF2F0EB);
  static const border = Color(0xFFE0DDD6);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF888780);
  static const textHint = Color(0xFFB4B2A9);
  static const gold = Color(0xFFC8A84B);
  static const goldLight = Color(0xFFFDF6E3);
  static const goldText = Color(0xFF8A6D1A);
  static const dark = Color(0xFF1A1A1A);
  static const white = Color(0xFFFFFFFF);
}

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});
  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final supabase = Supabase.instance.client;
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _policy = 'Female Only';
  String _propertyType = 'Apartment';
  String _university = 'American University in Cairo (AUC)';
  final List<XFile> _photos = [];
  final List<Uint8List> _webImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String _selectedAddress = '';
  double? _selectedLat;
  double? _selectedLng;

  final _amenities = <String, bool>{
    'Wi-Fi': true,
    'AC': true,
    'Cleaning Service': false,
    'Maintenance Included': false,
    'Furnished': true,
    'Parking': false,
  };
  final _amenityIcons = <String, IconData>{
    'Wi-Fi': Icons.wifi,
    'AC': Icons.ac_unit,
    'Cleaning Service': Icons.cleaning_services_outlined,
    'Maintenance Included': Icons.build_outlined,
    'Furnished': Icons.chair_outlined,
    'Parking': Icons.local_parking_outlined,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() => _webImages.add(bytes));
        } else {
          setState(() => _photos.add(image));
        }
      }
    } catch (e) {}
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Image Source',
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _imageSourceOption(
                        icon: Icons.camera_alt_outlined,
                        label: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        })),
                const SizedBox(width: 16),
                Expanded(
                    child: _imageSourceOption(
                        icon: Icons.photo_library_outlined,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageSourceOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Icon(icon, size: 32, color: AppColors.textPrimary),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.manrope(fontSize: 14))
        ]),
      ),
    );
  }

  Future<void> _publishListing() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields and pick a location')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Not logged in');
      final response = await supabase
          .from('property_listings')
          .insert({
            'landlord_id': user.id,
            'title': _titleController.text,
            'description': _descriptionController.text,
            'rent_price':
                double.parse(_priceController.text.replaceAll(',', '')),
            'property_type': _propertyType.toLowerCase(),
            'available_rooms': 1,
            'status': 'available',
          })
          .select()
          .single();
      final listingId = response['listing_id'];
      final folderPath = listingId.toString();
      List<String> imageUrls = [];

      for (int i = 0; i < _photos.length; i++) {
        final file = _photos[i];
        final fullPath = '$folderPath/$i.jpg';
        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          await supabase.storage
              .from('listing-images')
              .uploadBinary(fullPath, bytes);
        } else {
          await supabase.storage
              .from('listing-images')
              .upload(fullPath, File(file.path));
        }
        imageUrls.add(
            supabase.storage.from('listing-images').getPublicUrl(fullPath));
      }
      for (int i = 0; i < _webImages.length; i++) {
        final fullPath = '$folderPath/${_photos.length + i}.jpg';
        await supabase.storage
            .from('listing-images')
            .uploadBinary(fullPath, _webImages[i]);
        imageUrls.add(
            supabase.storage.from('listing-images').getPublicUrl(fullPath));
      }
      if (imageUrls.isNotEmpty) {
        await supabase
            .from('property_listings')
            .update({'image_url': imageUrls.first}).eq('listing_id', listingId);
      }
      await supabase.from('location').insert({
        'listing_id': listingId,
        'address': _selectedAddress,
        'street': '',
        'district': '',
        'city': 'Cairo',
        'nearby_universities': _university,
        'latitude': _selectedLat,
        'longitude': _selectedLng,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing published! 🎉')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _mediaSection(),
                    _divider(),
                    _propertyBasicsSection(),
                    _divider(),
                    _studentFocusSection(),
                    _divider(),
                    _amenitiesSection(),
                    _divider(),
                    _locationSection(),
                    _divider(),
                    _aboutSection(),
                    _publishSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }

  Widget _mediaSection() {
    final allPhotos = kIsWeb ? _webImages : _photos;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Media\nUpload', step: 'STEP 01 / 06'),
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1.5)),
              child: allPhotos.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.memory(_webImages.first, fit: BoxFit.cover)
                          : Image.file(File(_photos.first.path),
                              fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined,
                            size: 28, color: AppColors.textSecondary),
                        const SizedBox(height: 8),
                        Text('Upload Primary Photo',
                            style: GoogleFonts.manrope(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('You can add more after creating the listing',
                            style: GoogleFonts.manrope(
                                fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
            ),
          ),
          if (allPhotos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allPhotos.length,
                itemBuilder: (context, index) => Stack(
                  children: [
                    Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: kIsWeb
                            ? Image.memory(_webImages[index], fit: BoxFit.cover)
                            : Image.file(File(_photos[index].path),
                                fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (kIsWeb)
                              _webImages.removeAt(index);
                            else
                              _photos.removeAt(index);
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.close,
                                size: 12, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _propertyBasicsSection() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
                title: 'Property\nBasics', step: 'STEP 02 / 06'),
            const _InputField(
                label: 'PROPERTY TITLE',
                hint: 'e.g., Sun-drenched Studio near AUC'),
            const SizedBox(height: 14),
            const _InputField(
                label: 'MONTHLY RENT (EGP)',
                hint: '8,500',
                keyboardType: TextInputType.number),
            const SizedBox(height: 14),
            _DropdownField(
                label: 'PROPERTY TYPE',
                value: _propertyType,
                items: const ['Apartment', 'Studio', 'Room', 'Villa'],
                onChanged: (v) => setState(() => _propertyType = v!)),
          ],
        ),
      );

  Widget _studentFocusSection() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Student\nFocus', step: 'STEP 03 / 06'),
            Text('POLICY',
                style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.08)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Female Only', 'Male Only'].map((p) {
                final active = _policy == p;
                return GestureDetector(
                  onTap: () => setState(() => _policy = p),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: active ? AppColors.goldLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: active ? AppColors.gold : AppColors.border,
                          width: 0.5),
                    ),
                    child: Text(p,
                        style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: active
                                ? AppColors.goldText
                                : AppColors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            _DropdownField(
                label: 'NEAR UNIVERSITY',
                value: _university,
                items: egyptianUniversities,
                onChanged: (v) => setState(() => _university = v!)),
          ],
        ),
      );

  Widget _amenitiesSection() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Amenities', step: 'STEP 04 / 06'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _amenities.entries.map((e) {
                final active = e.value;
                return GestureDetector(
                  onTap: () => setState(() => _amenities[e.key] = !active),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.goldLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: active ? AppColors.gold : AppColors.border,
                          width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_amenityIcons[e.key] ?? Icons.check,
                            size: 14,
                            color: active
                                ? AppColors.goldText
                                : AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(e.key,
                            style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: active
                                    ? AppColors.goldText
                                    : AppColors.textPrimary)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget _locationSection() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Location', step: 'STEP 05 / 06'),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocationPickerScreen(
                      onPicked: (address, lat, lng) => setState(() {
                        _selectedAddress = address;
                        _selectedLat = lat;
                        _selectedLng = lng;
                      }),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedAddress.isEmpty
                            ? 'Tap to pick location on map'
                            : _selectedAddress,
                        style: GoogleFonts.manrope(
                            color: _selectedAddress.isEmpty
                                ? AppColors.textHint
                                : AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _aboutSection() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
                title: 'About the\nProperty', step: 'STEP 06 / 06'),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: 0.5)),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                style: GoogleFonts.manrope(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Describe the atmosphere, proximity to campus...',
                  hintStyle: GoogleFonts.manrope(
                      fontSize: 13, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _publishSection() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _publishListing,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_outlined,
                        size: 16, color: Colors.white),
                label: Text(_isLoading ? 'Publishing...' : 'Publish Listing',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(height: 8),
            Text('All done – ready to go!',
                style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.05)),
          ],
        ),
      );

  Widget _divider() => Container(
      height: 0.5,
      color: AppColors.border,
      margin: const EdgeInsets.only(top: 28));
}

// ==================== HELPER WIDGETS ====================
class _TopBar extends StatelessWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.border, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(children: const [
              Icon(Icons.arrow_back, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 6),
              Text('Add Listing',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
            ]),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 0.5)),
            child: const Icon(Icons.more_horiz,
                size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String step;
  const _SectionHeader({required this.title, required this.step});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                  height: 1.1)),
          Text(step,
              style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.04)),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label, hint;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  const _InputField(
      {required this.label,
      required this.hint,
      this.keyboardType = TextInputType.text,
      this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 0.08)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.manrope(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.manrope(fontSize: 14, color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.border, width: 0.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.border, width: 0.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.gold, width: 1)),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 0.08)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: AppColors.textSecondary),
              style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.textPrimary),
              dropdownColor: AppColors.white,
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false),
            child: const _NavItem(
                icon: Icons.grid_view, label: 'DASHBOARD', active: false),
          ),
          const _NavItem(
              icon: Icons.chat_bubble_outline,
              label: 'MESSAGES',
              active: false),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HostProfileScreen())),
            child: const _NavItem(
                icon: Icons.person, label: 'PROFILE', active: true),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavItem(
      {required this.icon, required this.label, required this.active});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 10, color: Colors.white, letterSpacing: 0.04)),
      ],
    );
  }
}
