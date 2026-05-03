import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _newMatches = true;
  bool _messages = true;
  bool _listings = true;
  bool _utilityBills = true;
  bool _roomRequests = true;
  bool _promotions = false;
  bool _emailNotifs = true;
  bool _pushNotifs = true;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('DELIVERY METHOD', [
              _toggle(Icons.phone_android, 'Push Notifications',
                  _pushNotifs,
                  (v) => setState(() => _pushNotifs = v)),
              _toggle(Icons.email_outlined, 'Email Notifications',
                  _emailNotifs,
                  (v) => setState(() => _emailNotifs = v)),
            ]),
            const SizedBox(height: 24),
            _section('ACTIVITY', [
              _toggle(Icons.favorite_outline, 'New Matches', _newMatches,
                  (v) => setState(() => _newMatches = v)),
              _toggle(Icons.chat_bubble_outline, 'Messages', _messages,
                  (v) => setState(() => _messages = v)),
              _toggle(Icons.home_outlined, 'New Listings', _listings,
                  (v) => setState(() => _listings = v)),
              _toggle(Icons.people_outline, 'Roommate Requests',
                  _roomRequests,
                  (v) => setState(() => _roomRequests = v)),
              _toggle(Icons.receipt_long, 'Utility Bills', _utilityBills,
                  (v) => setState(() => _utilityBills = v)),
            ]),
            const SizedBox(height: 24),
            _section('MARKETING', [
              _toggle(Icons.campaign_outlined, 'Promotions & Offers',
                  _promotions,
                  (v) => setState(() => _promotions = v)),
            ]),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Notification preferences saved!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fontColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Preferences',
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