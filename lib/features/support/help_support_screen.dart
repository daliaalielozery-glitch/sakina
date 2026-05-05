import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
        title: const Text('Help & Support',
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
            const Text('FREQUENTLY ASKED QUESTIONS',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Color(0xFF888888))),
            const SizedBox(height: 12),
            _faqItem(
              'How do I edit my listing?',
              'Go to My Listings, tap on the listing, then tap Edit.',
            ),
            _faqItem(
              'How do I contact a tenant?',
              'When a tenant messages you, you will see the conversation in the Messages tab.',
            ),
            _faqItem(
              'How do I change my password?',
              'Go to Settings → Security → Change Password.',
            ),
            _faqItem(
              'Can I delete my listing?',
              'Yes, open the listing details and tap Delete Listing.',
            ),
            const SizedBox(height: 24),
            const Text('CONTACT SUPPORT',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Color(0xFF888888))),
            const SizedBox(height: 12),
            _contactButton(
              'Email Us',
              Icons.email_outlined,
              () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'support@sakina.com',
                  query: 'subject=Help Request',
                );
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                }
              },
            ),
            const SizedBox(height: 12),
            _contactButton(
              'Call Support',
              Icons.phone_outlined,
              () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: '+20123456789');
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(question,
            style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C2416))),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer,
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    color: Color(0xFF4C463C))),
          ),
        ],
      ),
    );
  }

  Widget _contactButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.fontColor, size: 20),
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2416))),
          ],
        ),
      ),
    );
  }
}
