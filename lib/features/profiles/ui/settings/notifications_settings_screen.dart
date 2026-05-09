import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isSaving = false;

  bool _pushEnabled = true;
  bool _messageEnabled = true;
  bool _listingsEnabled = true;
  bool _matchesEnabled = true;
  bool _depositEnabled = true;

  String? _preferenceId;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      final row = await _supabase
          .from('notification_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          if (row != null) {
            _preferenceId = row['preference_id']?.toString();
            _pushEnabled = row['push_enabled'] ?? true;
            _messageEnabled = row['message_enabled'] ?? true;
            _listingsEnabled = row['listings_enabled'] ?? true;
            _matchesEnabled = row['matches_enabled'] ?? true;
            _depositEnabled = row['deposit_enabled'] ?? true;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = {
        'user_id': userId,
        'push_enabled': _pushEnabled,
        'message_enabled': _messageEnabled,
        'listings_enabled': _listingsEnabled,
        'matches_enabled': _matchesEnabled,
        'deposit_enabled': _depositEnabled,
      };

      if (_preferenceId != null) {
        // Update existing row
        await _supabase
            .from('notification_preferences')
            .update(data)
            .eq('preference_id', _preferenceId!);
      } else {
        // Insert new row with generated UUID
        final result = await _supabase
            .from('notification_preferences')
            .insert({
              ...data,
              'preference_id': const Uuid().v4(),
            })
            .select('preference_id')
            .single();
        _preferenceId = result['preference_id']?.toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Notification preferences saved!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2416)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications',
            style: TextStyle(
                color: Color(0xFF2C2416),
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section('NOTIFICATION TYPES', [
                    _toggle(Icons.phone_android, 'Push Notifications',
                        _pushEnabled,
                        (v) => setState(() => _pushEnabled = v)),
                    _toggle(Icons.chat_bubble_outline, 'Messages',
                        _messageEnabled,
                        (v) => setState(() => _messageEnabled = v)),
                    _toggle(Icons.home_outlined, 'New Listings',
                        _listingsEnabled,
                        (v) => setState(() => _listingsEnabled = v)),
                    _toggle(Icons.favorite_outline, 'New Matches',
                        _matchesEnabled,
                        (v) => setState(() => _matchesEnabled = v)),
                    _toggle(Icons.receipt_long, 'Deposits & Bills',
                        _depositEnabled,
                        (v) => setState(() => _depositEnabled = v)),
                  ]),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fontColor,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : const Text('Save Preferences',
                              style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Color(0xFF888888))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _toggle(IconData icon, String label, bool value,
      ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4C463C), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Color(0xFF2C2416))),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.fontColor,
            inactiveTrackColor: const Color(0xFFE4E2DF),
          ),
        ],
      ),
    );
  }
}