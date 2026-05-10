import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/compatibility_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/custom_action_btn.dart';
import 'package:sakina/features/profiles/ui/widgets/lifestyle_habit_item.dart';
import 'package:sakina/features/profiles/ui/widgets/roomate_profile_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoommateRequestScreen extends StatefulWidget {
  final String userId;       // tenant_id from edge fn (equals user_id)
  final String? matchPercentage;
  const RoommateRequestScreen({
    super.key,
    required this.userId,
    this.matchPercentage,
  });

  @override
  State<RoommateRequestScreen> createState() => _RoommateRequestScreenState();
}

class _RoommateRequestScreenState extends State<RoommateRequestScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;

  String _name = '';
  String _avatarUrl = '';
  String _university = '';
  String _circadianRhythm = '';
  String _socialThreshold = '';
  String _smokingPreferences = '';
  String _environmentalOrder = '';
  double _cleanlinessScore = 0.7;
  double _socialScore = 0.7;
  double _sleepScore = 0.7;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      // tenant_id == user_id in this app's schema.
      // We try users table directly first, then fall back via tenants table.
      String resolvedUserId = widget.userId;

      // Try resolving user_id via tenants table in case tenant_id != user_id
      final tenantRow = await _supabase
          .from('tenants')
          .select('user_id, university')
          .eq('tenant_id', widget.userId)
          .maybeSingle();

      if (tenantRow != null && tenantRow['user_id'] != null) {
        resolvedUserId = tenantRow['user_id'].toString();
      }

      final results = await Future.wait([
        _supabase
            .from('users')
            .select('full_name, avatar_url')
            .eq('user_id', resolvedUserId)
            .maybeSingle(),
        _supabase
            .from('tenants')
            .select('university')
            .eq('user_id', resolvedUserId)
            .maybeSingle(),
        _supabase
            .from('lifestyle_profile')
            .select('circadian_rhythm, social_threshold, smoking_preferences, environmental_order')
            .eq('user_id', resolvedUserId)
            .maybeSingle(),
      ]);

      final user = results[0];
      final tenant = results[1];
      final lifestyle = results[2];

      // Derive compatibility scores from lifestyle data
      double cleanlinessScore = 0.7;
      double socialScore = 0.7;
      double sleepScore = 0.7;

      if (lifestyle != null) {
        final myLifestyle = await _supabase
            .from('lifestyle_profile')
            .select('circadian_rhythm, social_threshold, environmental_order')
            .eq('user_id', _supabase.auth.currentUser?.id ?? '')
            .maybeSingle();

        if (myLifestyle != null) {
          // Simple score: 1.0 if same, 0.5 if different
          sleepScore = lifestyle['circadian_rhythm'] == myLifestyle['circadian_rhythm'] ? 1.0 : 0.5;
          socialScore = lifestyle['social_threshold'] == myLifestyle['social_threshold'] ? 1.0 : 0.5;
          cleanlinessScore = lifestyle['environmental_order'] == myLifestyle['environmental_order'] ? 1.0 : 0.5;
        }
      }

      if (mounted) {
        setState(() {
          _name = user?['full_name']?.toString() ?? 'Unknown';
          _avatarUrl = user?['avatar_url']?.toString() ?? '';
          _university = tenantRow?['university']?.toString() ??
              tenant?['university']?.toString() ?? 'University not set';
          _circadianRhythm = lifestyle?['circadian_rhythm']?.toString() ?? '';
          _socialThreshold = lifestyle?['social_threshold']?.toString() ?? '';
          _smokingPreferences = lifestyle?['smoking_preferences']?.toString() ?? '';
          _environmentalOrder = lifestyle?['environmental_order']?.toString() ?? '';
          _cleanlinessScore = cleanlinessScore;
          _socialScore = socialScore;
          _sleepScore = sleepScore;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatLabel(String value) => value
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const Myappbar(showProfile: true, title: 'Sakina'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                children: [
                  SizedBox(height: 24.h),

                  RoomateProfileCard(
                    imageUrl: _avatarUrl.isNotEmpty
                        ? _avatarUrl
                        : 'https://placehold.co/200x200/png',
                    profession: 'Student',
                    userName: _name,
                    university: _university,
                    matchPercentage: widget.matchPercentage,
                  ),
                  SizedBox(height: 24.h),

                  // Compatibility
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEADEC6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('COMPATIBILITY',
                            style: TextStyle(
                                color: const Color(0xFF6A624F),
                                fontSize: 10.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 2)),
                        SizedBox(height: 16.h),
                        CompatibilityBar(label: 'Cleanliness', progress: _cleanlinessScore),
                        SizedBox(height: 12.h),
                        CompatibilityBar(label: 'Social Style', progress: _socialScore),
                        SizedBox(height: 12.h),
                        CompatibilityBar(label: 'Sleep Cycle', progress: _sleepScore),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Lifestyle habits grid
                  if (_circadianRhythm.isNotEmpty ||
                      _socialThreshold.isNotEmpty ||
                      _smokingPreferences.isNotEmpty ||
                      _environmentalOrder.isNotEmpty)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        if (_circadianRhythm.isNotEmpty)
                          LifestyleHabitItem(
                              icon: Icons.access_time,
                              label: _formatLabel(_circadianRhythm),
                              subtitle: 'Schedule'),
                        if (_socialThreshold.isNotEmpty)
                          LifestyleHabitItem(
                              icon: Icons.people_outline,
                              label: _formatLabel(_socialThreshold),
                              subtitle: 'Social'),
                        if (_smokingPreferences.isNotEmpty)
                          LifestyleHabitItem(
                              icon: Icons.smoke_free,
                              label: _formatLabel(_smokingPreferences),
                              subtitle: 'Smoking'),
                        if (_environmentalOrder.isNotEmpty)
                          LifestyleHabitItem(
                              icon: Icons.cleaning_services_outlined,
                              label: _formatLabel(_environmentalOrder),
                              subtitle: 'Cleanliness'),
                      ],
                    ),
                  SizedBox(height: 24.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomActionBtn(
                          text: 'Decline',
                          backgroundColor: const Color(0xFFE4E2DF),
                          textColor: const Color(0xFF1B1C1A),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomActionBtn(
                          text: 'Connect',
                          backgroundColor: AppColors.primaryBrown,
                          textColor: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
    );
  }
}