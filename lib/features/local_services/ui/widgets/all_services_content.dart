import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/features/local_services/repository/services_repository.dart';
import 'package:sakina/features/local_services/ui/service_details_screen.dart';
import 'package:sakina/features/local_services/ui/widgets/service_card.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';
import 'package:sakina/features/local_services/ui/widgets/special_offer_banner.dart';

class AllServicesContent extends StatefulWidget {
  const AllServicesContent({super.key});

  @override
  State<AllServicesContent> createState() => _AllServicesContentState();
}

class _AllServicesContentState extends State<AllServicesContent> {
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
      final services = await _repo.getAllServices();
      if (mounted) setState(() { _services = services; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  ServiceCategory _toCategory(String cat) {
    switch (cat) {
      case 'laundry': return ServiceCategory.laundry;
      case 'food': return ServiceCategory.food;
      case 'maintenance': return ServiceCategory.maintenance;
      default: return ServiceCategory.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        ..._services.map((s) => GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: s))),
          child: ServiceCard(
            title: s.name,
            description: s.description,
            rating: s.rating.toStringAsFixed(1),
            distance: s.distance ?? '',
            imageUrl: s.imageUrl ?? 'https://placehold.co/342x192/png',
            category: _toCategory(s.category),
          ),
        )),
        SizedBox(height: 32.h),
        const SpecialOfferBanner(),
      ],
    );
  }
}