import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'host_profile_screen.dart';

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

class ListingDetailsScreen extends StatefulWidget {
  final String listingId;
  final String title;
  final String location;
  final String price;
  final String beds;
  final String tag;
  final String imageUrl;

  const ListingDetailsScreen({
    super.key,
    required this.listingId,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.tag,
    this.imageUrl = '',
  });

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  late String _policy;
  late String _propertyType;
  late String _university;
  late bool _isAvailable;

  final List<XFile> _photos = [];
  final ImagePicker _picker = ImagePicker();

  final _titleController = TextEditingController();
  final _rentController = TextEditingController();
  final _locationController = TextEditingController();
  final _bedsController = TextEditingController();
  final _aboutController = TextEditingController();

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
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _rentController.text = widget.price;
    _locationController.text = widget.location;
    _bedsController.text = widget.beds;
    _aboutController.text = '';
    _policy = 'Female Only';
    _propertyType = 'Apartment';
    _university = 'American University in Cairo (AUC)';
    _isAvailable = widget.tag != 'FULLY BOOKED';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _rentController.dispose();
    _locationController.dispose();
    _bedsController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) setState(() => _photos.add(image));
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // ✅ Save Changes to Supabase
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      String? imageUrl;

      // Upload new image if selected
      if (_photos.isNotEmpty) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        if (kIsWeb) {
          final bytes = await _photos.first.readAsBytes();
          await supabase.storage
              .from('listing-images')
              .uploadBinary(fileName, bytes);
        } else {
          await supabase.storage
              .from('listing-images')
              .upload(fileName, File(_photos.first.path));
        }
        imageUrl =
            supabase.storage.from('listing-images').getPublicUrl(fileName);
      }

      final updateData = {
        'title': _titleController.text,
        'description': _aboutController.text,
        'rent_price': double.parse(_rentController.text.replaceAll(',', '')),
        'property_type': _propertyType.toLowerCase(),
        'status': _isAvailable ? 'available' : 'fully_booked',
      };

      if (imageUrl != null) {
        updateData['image_url'] = imageUrl;
      }

      await supabase
          .from('property_listings')
          .update(updateData)
          .eq('listing_id', widget.listingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing updated successfully! ✅')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Delete Listing from Supabase
  Future<void> _deleteListing() async {
    // Confirm dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await supabase
          .from('property_listings')
          .delete()
          .eq('listing_id', widget.listingId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing deleted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Image Source',
                style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
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
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _imageSourceOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _imageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.textPrimary),
            const SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.manrope(
                    fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                    _actionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }

  Widget _mediaSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Listing\nPhotos', step: 'STEP 01 / 05'),
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: _photos.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(_photos.first.path, fit: BoxFit.cover)
                          : Image.file(File(_photos.first.path),
                              fit: BoxFit.cover),
                    )
                  : widget.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(widget.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 160),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined,
                                size: 28, color: AppColors.textSecondary),
                            const SizedBox(height: 8),
                            Text('Tap to change primary photo',
                                style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary)),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _propertyBasicsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Property\nBasics', step: 'STEP 02 / 05'),
          _InputField(
              label: 'PROPERTY TITLE',
              hint: 'e.g., Sun-drenched Studio near AUC',
              controller: _titleController),
          const SizedBox(height: 14),
          _InputField(
              label: 'MONTHLY RENT (EGP)',
              hint: '8,500',
              keyboardType: TextInputType.number,
              controller: _rentController),
          const SizedBox(height: 14),
          _InputField(
              label: 'LOCATION (AREA/NEIGHBORHOOD)',
              hint: 'New Cairo, Fifth Settlement',
              controller: _locationController),
          const SizedBox(height: 14),
          _DropdownField(
            label: 'PROPERTY TYPE',
            value: _propertyType,
            items: const ['Apartment', 'Studio', 'Room', 'Villa'],
            onChanged: (v) => setState(() => _propertyType = v!),
          ),
          const SizedBox(height: 14),
          Text('AVAILABILITY',
              style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.08)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Available', 'Fully Booked'].map((p) {
              final active = p == 'Available' ? _isAvailable : !_isAvailable;
              return GestureDetector(
                onTap: () => setState(() => _isAvailable = p == 'Available'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        ],
      ),
    );
  }

  Widget _studentFocusSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Student\nFocus', step: 'STEP 03 / 05'),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            items: const [
              'American University in Cairo (AUC)',
              'Cairo University',
              'Ain Shams University',
              'GUC',
            ],
            onChanged: (v) => setState(() => _university = v!),
          ),
        ],
      ),
    );
  }

  Widget _amenitiesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Amenities', step: 'STEP 04 / 05'),
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
  }

  Widget _locationSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Location',
                  style: GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textPrimary)),
              Text(widget.location,
                  style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: const _MapPlaceholder(),
          ),
        ],
      ),
    );
  }

  Widget _aboutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'About the\nProperty', step: 'STEP 05 / 05'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: TextField(
              controller: _aboutController,
              maxLines: 5,
              style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Describe the property...',
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
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text('Save Changes',
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _deleteListing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.redAccent, width: 1)),
                elevation: 0,
              ),
              child: Text('Delete Listing',
                  style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 0.5,
        color: AppColors.border,
        margin: const EdgeInsets.only(top: 28),
      );
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                const Icon(Icons.arrow_back,
                    size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text('Listing Details',
                    style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
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
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const _InputField({
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

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
          style:
              GoogleFonts.manrope(fontSize: 14, color: AppColors.textPrimary),
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
              borderSide: const BorderSide(color: AppColors.border, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gold, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

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
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
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
                icon: Icons.person_outline, label: 'PROFILE', active: false),
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

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: Size.infinite, painter: _GridPainter()),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
              color: AppColors.dark, shape: BoxShape.circle),
          child: const Center(
              child: Icon(Icons.location_on, size: 16, color: Colors.white)),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 46) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 26) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
