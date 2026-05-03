import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sakina/core/theme/app_colors.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  String _selected = 'en';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية', 'flag': '🇪🇬'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selected = context.locale.languageCode;
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
        title: const Text('Language',
            style: TextStyle(
                color: Color(0xFF2C2416),
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SELECT LANGUAGE',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Color(0xFF888888))),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _languages.asMap().entries.map((entry) {
                  final i = entry.key;
                  final lang = entry.value;
                  final isSelected = _selected == lang['code'];
                  return Column(
                    children: [
                      if (i > 0)
                        const Divider(
                            height: 1,
                            indent: 60,
                            endIndent: 16,
                            color: Color(0xFFE0D8CC)),
                      ListTile(
                        leading: Text(lang['flag']!,
                            style: const TextStyle(fontSize: 28)),
                        title: Text(lang['name']!,
                            style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2C2416))),
                        subtitle: Text(lang['native']!,
                            style: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                color: Color(0xFF888888))),
                        trailing: isSelected
                            ? Icon(Icons.check_circle,
                                color: AppColors.fontColor, size: 22)
                            : const Icon(Icons.circle_outlined,
                                color: Color(0xFFD0C8BC), size: 22),
                        onTap: () {
                          setState(() => _selected = lang['code']!);
                          context.setLocale(Locale(lang['code']!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Language changed to ${lang['name']}'),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}