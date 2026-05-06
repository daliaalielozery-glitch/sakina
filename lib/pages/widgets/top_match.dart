import 'package:flutter/material.dart';
import 'package:sakina/core/theme/app_colors.dart';
import 'package:sakina/features/home/bloc/home_bloc.dart';

class TopMatch extends StatelessWidget {
  final List<TenantMatch> matches;
  const TopMatch({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) return const SizedBox.shrink();

    return Container(
      color: AppColors.themeColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Top Matches',
                style: TextStyle(
                  color: Color(0xFF120A00),
                  fontSize: 24,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  letterSpacing: -0.60,
                ),
              ),
              Text(
                'SEE ALL',
                style: TextStyle(
                  color: Color(0xFF4C463C),
                  fontSize: 12,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  letterSpacing: 1.20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _TopMatchCard(match: matches.first),
        ],
      ),
    );
  }
}

class _TopMatchCard extends StatelessWidget {
  final TenantMatch match;
  const _TopMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBeig,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E0B6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  match.university?.isNotEmpty == true
                      ? match.university!.toUpperCase()
                      : 'SAKINA MATCH',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A6F65),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFD8D0C0),
                backgroundImage: match.avatarUrl?.isNotEmpty == true
                    ? NetworkImage(match.avatarUrl!)
                    : null,
                child: match.avatarUrl == null || match.avatarUrl!.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.white54)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (match.tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: match.tags.map(_buildTag).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            match.bio?.isNotEmpty == true ? match.bio! : 'No bio added yet.',
            style: const TextStyle(
              color: Color(0xFF4C463C),
              fontSize: 14,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              height: 1.63,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1C1C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('View Profile',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Manrope', fontWeight: FontWeight.w400, height: 1.43, letterSpacing: 0.35)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAE8E5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE8E5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4C463C),
          fontSize: 10,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: 0.50,
        ),
      ),
    );
  }
}