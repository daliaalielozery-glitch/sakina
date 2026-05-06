import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/local_services/repository/services_repository.dart';
import 'package:sakina/features/local_services/ui/service_details_screen.dart';
import 'package:sakina/features/local_services/ui/widgets/service_card.dart';
import 'package:sakina/features/local_services/ui/widgets/service_model.dart';

class FoodContent extends StatefulWidget {
  const FoodContent({super.key});

  @override
  State<FoodContent> createState() => _FoodContentState();
}

class _FoodContentState extends State<FoodContent> {
  final _repo = ServicesRepository();
  List<ServiceData> _services = [];
  List<ServiceData> _filtered = [];
  bool _loading = true;
  String _selectedCategory = 'all';

  final List<String> _categories = ['all', 'egyptian', 'italian', 'healthy', 'quick_bites'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final services = await _repo.getServicesByCategory('food');
      if (mounted) setState(() {
        _services = services;
        _filtered = services;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filterByCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
      _filtered = cat == 'all'
          ? _services
          : _services.where((s) => s.subCategory == cat).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_services.isEmpty) return const Center(child: Text('No food services available.'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text(cat.replaceAll('_', ' ').toUpperCase()),
                  selected: isSelected,
                  onSelected: (_) => _filterByCategory(cat),
                  backgroundColor: AppColors.unSelectedChip,
                  selectedColor: AppColors.primaryBeig,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 32.h),
        ...(_filtered.isEmpty ? _services : _filtered).map((s) => ServiceCard(
          category: ServiceCategory.food,
          title: s.name,
          description: s.description,
          rating: s.rating.toStringAsFixed(1),
          distance: s.distance ?? '',
          imageUrl: s.imageUrl ?? 'https://placehold.co/342x214/png',
          priceRange: 'DETAILS',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ServiceDetailsScreen(service: s))),
        )),
      ],
    );
  }
}