import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakina/landlord/host_profile_screen.dart';
import 'package:sakina/landlord/edit_profile_screen.dart';
import 'package:sakina/features/profiles/ui/settings/notifications_settings_screen.dart';
import 'package:sakina/features/profiles/ui/settings/privacy_screen.dart';
import 'package:sakina/features/profiles/ui/settings/security_screen.dart';
import 'package:sakina/features/profiles/ui/settings/translation_screen.dart';
import '../features/support/help_support_screen.dart';
import '../features/support/privacy_policy_screen.dart';
import '../features/support/about_sakina_screen.dart';
import 'package:sakina/features/auth/login_screen.dart';

class LandlordSidebar extends StatefulWidget {
  const LandlordSidebar({super.key});

  @override
  State<LandlordSidebar> createState() => _LandlordSidebarState();
}

class _LandlordSidebarState extends State<LandlordSidebar> {
  final supabase = Supabase.instance.client;

  static const Color bg = Color(0xFFF5F3EF);
  static const Color card = Color(0xFFEEE9DF);
  static const Color brown = Color(0xFF1B1209);
  static const Color muted = Color(0xFF7A746C);
  static const Color border = Color(0xFFE8E1D7);

  String _fullName = '';
  String _email = '';
  String? _avatarUrl;
  bool _isLoading = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final userResponse = await supabase
          .from('users')
          .select('full_name, email, avatar_url')
          .eq('user_id', userId)
          .maybeSingle();

      setState(() {
        _fullName = userResponse?['full_name'] ??
            supabase.auth.currentUser?.userMetadata?['full_name'] ??
            supabase.auth.currentUser?.email?.split('@')[0] ??
            'User';
        _email =
            userResponse?['email'] ?? supabase.auth.currentUser?.email ?? '';
        _avatarUrl = userResponse?['avatar_url'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    // Close the drawer
    Navigator.pop(context);
    // Sign out from Supabase
    await supabase.auth.signOut();
    // Go to login screen (replace LoginScreen with your actual login screen class name)
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen(role: 'landlord')),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bg,
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Header (same as before)
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: const BoxDecoration(
                      color: brown,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'My Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 22),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                  fullName: _fullName,
                                  bio: '',
                                  avatarUrl: _avatarUrl,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: ClipOval(
                                  child: _avatarUrl != null &&
                                          _avatarUrl!.isNotEmpty
                                      ? Image.network(
                                          _avatarUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.person,
                                                  size: 40,
                                                  color: Colors.white),
                                        )
                                      : const Icon(Icons.person,
                                          size: 40, color: Colors.white),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: brown, width: 1.5),
                                  ),
                                  child: const Icon(Icons.edit,
                                      size: 12, color: brown),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Manrope',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontFamily: 'Manrope',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            'LANDLORD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Menu Items
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // ACCOUNT SECTION
                          _buildSectionTitle('ACCOUNT'),
                          _buildMenuItem(
                            icon: Icons.person_outline,
                            title: 'My Profile',
                            subtitle: 'View and edit your profile',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HostProfileScreen()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.edit_outlined,
                            title: 'Edit Profile',
                            subtitle: 'Update your information',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    fullName: _fullName,
                                    bio: '',
                                    avatarUrl: _avatarUrl,
                                  ),
                                ),
                              );
                            },
                          ),

                          _buildDivider(),

                          // SETTINGS SECTION (new)
                          _buildSectionTitle('SETTINGS'),

                          _buildMenuItem(
                            icon: Icons.security_outlined,
                            title: 'Security',
                            subtitle: 'Change password, 2FA',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SecurityScreen()),
                              );
                            },
                          ),

                          _buildMenuItem(
                            icon: Icons.lock_outline,
                            title: 'Privacy',
                            subtitle: 'Manage what others see',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const PrivacySettingsScreen()),
                              );
                            },
                          ),

                          _buildMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle: 'Adjust alert preferences',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const NotificationsSettingsScreen()),
                              );
                            },
                          ),

                          _buildMenuItem(
                            icon: Icons.language_outlined,
                            title: 'Language',
                            subtitle: 'Change app language',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const TranslationScreen()),
                              );
                            },
                          ),

                          _buildDivider(),

                          // SUPPORT SECTION
                          _buildSectionTitle('SUPPORT'),

                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help & Support',
                            subtitle: 'FAQs and contact us',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HelpSupportScreen()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.shield_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'Read our privacy policy',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const PrivacyPolicyScreen()),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.info_outline,
                            title: 'About Sakina',
                            subtitle: 'Version 2.4.0',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AboutSakinaScreen()),
                              );
                            },
                          ),

                          _buildDivider(),

                          // Logout
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            child: GestureDetector(
                              onTap: _logout,
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout,
                                        color: Colors.red.shade600, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: muted,
            letterSpacing: 1,
            fontFamily: 'Manrope',
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: brown, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: brown,
          fontFamily: 'Manrope',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: muted,
          fontFamily: 'Manrope',
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: muted, size: 20),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: border,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
