import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/local_services/repository/services_repository.dart';
import 'package:sakina/features/local_services/ui/widgets/partner_card.dart';
import 'package:sakina/features/local_services/ui/widgets/specialty_card.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class MaintenanceContent extends StatefulWidget {
  const MaintenanceContent({super.key});

  @override
  State<MaintenanceContent> createState() => _MaintenanceContentState();
}

class _MaintenanceContentState extends State<MaintenanceContent> {
  final _repo = ServicesRepository();
  List<ServiceData> _services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final services = await _repo.getServicesByCategory('maintenance');
      if (mounted) setState(() { _services = services; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        SizedBox(width: 16.w),
        const Expanded(child: Divider(color: Color(0x26CFC5B8))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_services.isEmpty) return const Center(child: Text('No maintenance services available.'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Specialties'),
        SizedBox(height: 24.h),
        Row(
          spacing: 15.w,
          children: [
            Expanded(child: SpecialtyCard(title: 'Plumbing', onTap: () {})),
            Expanded(child: SpecialtyCard(title: 'Electrical', isSelected: true, onTap: () {})),
            Expanded(child: SpecialtyCard(title: 'Furniture Assembly', onTap: () {})),
          ],
        ),
        SizedBox(height: 32.h),
        ..._services.map((s) => PartnerCard(
          title: s.name,
          description: s.description,
          rating: s.rating.toStringAsFixed(1),
          tags: const ['Verified', 'Professional'],
          imageUrl: s.imageUrl ?? 'https://placehold.co/385x168/png',
          category: ServiceCategory.maintenance,
          onAction: () {},
        )),
      ],
    );
  }
}