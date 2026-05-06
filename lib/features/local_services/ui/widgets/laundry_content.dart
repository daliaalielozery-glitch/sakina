import 'package:flutter/material.dart';
import 'package:sakina/features/local_services/repository/services_repository.dart';
import 'package:sakina/features/local_services/ui/service_details_screen.dart';
import 'package:sakina/features/local_services/ui/widgets/service_card.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class LaundryContent extends StatefulWidget {
  const LaundryContent({super.key});

  @override
  State<LaundryContent> createState() => _LaundryContentState();
}

class _LaundryContentState extends State<LaundryContent> {
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
      final services = await _repo.getServicesByCategory('laundry');
      if (mounted) setState(() { _services = services; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_services.isEmpty) return const Center(child: Text('No laundry services available.'));

    return Column(
      children: _services.map((s) => GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: s))),
        child: ServiceCard(
          category: ServiceCategory.laundry,
          title: s.name,
          description: s.description,
          rating: s.rating.toStringAsFixed(1),
          distance: s.distance ?? '',
          imageUrl: s.imageUrl ?? 'https://placehold.co/342x256/png',
          tag: 'FEATURED',
        ),
      )).toList(),
    );
  }
}