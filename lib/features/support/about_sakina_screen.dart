import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';

class AboutSakinaScreen extends StatelessWidget {
  const AboutSakinaScreen({super.key});

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
        title: const Text('About Sakina',
            style: TextStyle(
                color: Color(0xFF2C2416),
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.fontColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.home_work, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Sakina',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2416))),
            const SizedBox(height: 8),
            const Text('Version 2.4.0',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Color(0xFF888888))),
            const SizedBox(height: 24),
            const Text(
              'Sakina is a platform connecting students with safe, verified housing and trusted landlords. We believe in creating a secure and transparent rental experience for everyone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF4C463C)),
            ),
            const SizedBox(height: 32),
            _infoRow('Email:', 'hello@sakina.com'),
            _infoRow('Website:', 'www.sakina.com'),
            _infoRow('Founded:', '2025'),
            const SizedBox(height: 32),
            const Text('© 2026 Sakina. All rights reserved.',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: Color(0xFF888888))),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2416))),
          ),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: Color(0xFF4C463C))),
        ],
      ),
    );
  }
}
