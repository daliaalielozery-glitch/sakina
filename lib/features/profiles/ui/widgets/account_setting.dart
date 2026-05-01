import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';



class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.person_outline, 'label': 'Personal information'},
      {'icon': Icons.shield_outlined, 'label': 'Security'},
      {'icon': Icons.lock_outline, 'label': 'Privacy'},
      {'icon': Icons.notifications_none_outlined, 'label': 'Notifications'},
      {'icon': Icons.credit_card_outlined, 'label': 'Payments'},
      {'icon': Icons.translate_outlined, 'label': 'Translation'},
      {'icon': Icons.accessibility_new_outlined, 'label': 'Accessibility'},
      {'icon': Icons.switch_account_outlined, 'label': 'switch account'},
    ];

    return Scaffold(
      backgroundColor: AppColors.themeColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF9F6B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2416)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account settings',
          style: TextStyle(
            color: Color(0xFF2C2416),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 0.5,
                indent: 56,
                endIndent: 16,
                color: Color(0xFFD4C4A8),
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Icon(
                    item['icon'] as IconData,
                    color: const Color(0xFF2C2416),
                    size: 22,
                  ),
                  title: Text(
                    item['label'] as String,
                    style: const TextStyle(
                      color: Color(0xFF2C2416),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFAA9880),
                    size: 20,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              'VERSION 26.13 (204595)',
              style: TextStyle(
                color: const Color(0xFF8B7355),
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}