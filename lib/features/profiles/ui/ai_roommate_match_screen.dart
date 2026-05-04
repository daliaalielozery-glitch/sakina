import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/core/widgets/custom_app_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/compatibility_bar.dart';
import 'package:sakina/features/profiles/ui/widgets/custom_action_btn.dart';
import 'package:sakina/features/profiles/ui/widgets/lifestyle_habit_item.dart';
import 'package:sakina/features/profiles/ui/widgets/roomate_profile_card.dart';

class AiRoommateMatchScreen extends StatefulWidget {
  const AiRoommateMatchScreen({super.key});

  @override
  State<AiRoommateMatchScreen> createState() => _AiRoommateMatchScreenState();
}

class _AiRoommateMatchScreenState extends State<AiRoommateMatchScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _error;

  String _matchName = '';
  String _matchAvatar = '';
  String _matchUniversity = '';
  String _matchProfession = '';
  String _matchPersona = '';
  double _matchScore = 0;
  double _cleanlinessScore = 0;
  double _socialScore = 0;
  double _sleepScore = 0;
  String _circadianRhythm = '';
  String _smokingPreferences = '';
  String _socialThreshold = '';
  String _environmentalOrder = '';

  @override
  void initState() {
    super.initState();
    _fetchMatch();
  }

  Future<void> _fetchMatch() async {
    try {
      setState(() { _isLoading = true; _error = null; });

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase.functions.invoke(
        'ai-match',
        body: {'user_id': userId},
      );

      if (response.data == null) {
        setState(() { _error = 'No match found'; _isLoading = false; });
        return;
      }

      final data = response.data as Map<String, dynamic>;
      final roommateMatches = data['roommate_matches'] as List? ?? [];

      if (roommateMatches.isEmpty) {
        setState(() { _error = 'No roommate matches found yet.\nComplete your lifestyle survey to get matched!'; _isLoading = false; });
        return;
      }

      final topMatch = roommateMatches.first as Map<String, dynamic>;
      final matchUserId = topMatch['user_id'] as String?;

      if (matchUserId == null) {
        setState(() { _error = 'Invalid match data'; _isLoading = false; });
        return;
      }

      final results = await Future.wait([
        _supabase
            .from('users')
            .select('full_name, avatar_url')
            .eq('user_id', matchUserId)
            .maybeSingle(),
        _supabase
            .from('tenants')
            .select('university')
            .eq('user_id', matchUserId)
            .maybeSingle(),
        _supabase
            .from('lifestyle_profile')
            .select('circadian_rhythm, social_threshold, smoking_preferences, environmental_order')
            .eq('user_id', matchUserId)
            .maybeSingle(),
      ]);

      final user = results[0] as Map<String, dynamic>?;
      final tenant = results[1] as Map<String, dynamic>?;
      final lifestyle = results[2] as Map<String, dynamic>?;
      final scores = topMatch['scores'] as Map<String, dynamic>? ?? {};

      if (mounted) {
        setState(() {
          _matchName = user?['full_name'] ?? 'Unknown';
          _matchAvatar = user?['avatar_url'] ?? '';
          _matchUniversity = tenant?['university'] ?? 'University not set';
          _matchProfession = 'Student';
          _matchScore = ((topMatch['score'] as num?) ?? 0).toDouble() * 100;
          _cleanlinessScore = ((scores['cleanliness'] as num?) ?? 0).toDouble();
          _socialScore = ((scores['social'] as num?) ?? 0).toDouble();
          _sleepScore = ((scores['circadian'] as num?) ?? 0).toDouble();
          _circadianRhythm = lifestyle?['circadian_rhythm'] ?? '';
          _smokingPreferences = lifestyle?['smoking_preferences'] ?? '';
          _socialThreshold = lifestyle?['social_threshold'] ?? '';
          _environmentalOrder = lifestyle?['environmental_order'] ?? '';
          _matchPersona = _buildPersona();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _error = e.toString(); _isLoading = false; });
      }
    }
  }

  String _buildPersona() {
    final parts = <String>[];
    if (_circadianRhythm.isNotEmpty) parts.add(_circadianRhythm.replaceAll('_', ' '));
    if (_socialThreshold.isNotEmpty) parts.add(_socialThreshold);
    if (_environmentalOrder.isNotEmpty) parts.add(_environmentalOrder.replaceAll('_', ' '));
    if (_smokingPreferences.isNotEmpty) parts.add(_smokingPreferences.replaceAll('_', ' '));
    if (parts.isEmpty) return '"A student looking for a compatible living situation."';
    return '"A ${parts.join(', ')} student at $_matchUniversity, looking for a comfortable and compatible living situation."';
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
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_outline,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Manrope',
                              color: Colors.grey,
                              fontSize: 15),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _fetchMatch,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.fontColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text('Try Again',
                              style: TextStyle(fontFamily: 'Manrope')),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchMatch,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        RoomateProfileCard(
                          imageUrl: _matchAvatar.isNotEmpty
                              ? _matchAvatar
                              : 'https://thumbs.dreamstime.com/b/avatar-profile-icon-flat-style-female-user-vector-illustration-isolated-background-women-sign-business-concept-321407993.jpg',
                          profession: _matchProfession,
                          userName: _matchName,
                          university: _matchUniversity,
                          matchPercentage:
                              '${_matchScore.toStringAsFixed(0)}%',
                        ),
                        const SizedBox(height: 24),

                        // Persona
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('THE PERSONA',
                                  style: TextStyle(
                                      color: Color(0xFF4C463C),
                                      fontSize: 10,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 2)),
                              const SizedBox(height: 16),
                              Text(_matchPersona,
                                  style: const TextStyle(
                                      color: Color(0xFF1B1C1A),
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 24),
                              CustomActionBtn(
                                text: 'Message $_matchName',
                                icon: Icons.chat_bubble_outline,
                                backgroundColor: AppColors.primaryBrown,
                                textColor: Colors.white,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 16),
                              CustomActionBtn(
                                text: 'View Room Details',
                                icon: Icons.meeting_room_outlined,
                                backgroundColor: const Color(0xFFE4E2DF),
                                textColor: const Color(0xFF1B1C1A),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Compatibility
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEADEC6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('COMPATIBILITY',
                                  style: TextStyle(
                                      color: Color(0xFF6A624F),
                                      fontSize: 10,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 2)),
                              const SizedBox(height: 16),
                              CompatibilityBar(
                                  label: 'Cleanliness',
                                  progress: _cleanlinessScore.clamp(0.0, 1.0)),
                              const SizedBox(height: 12),
                              CompatibilityBar(
                                  label: 'Social Style',
                                  progress: _socialScore.clamp(0.0, 1.0)),
                              const SizedBox(height: 12),
                              CompatibilityBar(
                                  label: 'Sleep Cycle',
                                  progress: _sleepScore.clamp(0.0, 1.0)),
                            ],
                          ),
                        ),

                        // Lifestyle
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Lifestyle & Habits',
                                  style: TextStyle(
                                      color: Color(0xFF1B1C1A),
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 24),
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
                                        icon: Icons.nightlight_outlined,
                                        label: _formatLabel(_circadianRhythm)),
                                  if (_socialThreshold.isNotEmpty)
                                    LifestyleHabitItem(
                                        icon: Icons.people_outline,
                                        label: _formatLabel(_socialThreshold)),
                                  if (_smokingPreferences.isNotEmpty)
                                    LifestyleHabitItem(
                                        icon: Icons.smoke_free,
                                        label: _formatLabel(_smokingPreferences)),
                                  if (_environmentalOrder.isNotEmpty)
                                    LifestyleHabitItem(
                                        icon: Icons.cleaning_services_outlined,
                                        label: _formatLabel(_environmentalOrder)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
    );
  }
}