import 'package:flutter/material.dart';

class CommunityVoiceWidget extends StatelessWidget {
  const CommunityVoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0EBE0),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Community Voice',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
              // const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Color(0xFF4C463C),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Rating row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Stars
              Row(
                children: List.generate(5, (i) {
                  if (i < 4) {
                    return const Icon(Icons.star_rounded,
                        color: Color(0xFFF5A623), size: 26);
                  } else {
                    return const Icon(Icons.star_half_rounded,
                        color: Color(0xFFF5A623), size: 26);
                  }
                }),
              ),
              const SizedBox(width: 6),
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(42 Student Reviews)',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7A7060),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Reviews ──
          const _ReviewCard(
            avatarAsset: 'https://plus.unsplash.com/premium_photo-1689565611422-b2156cc65e47?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bWFuJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
            name: 'Omar Khaled',
            tag: 'ENGINEERING, YEAR 3',
            review:
                '"The study lounge is actually quiet. Best part is being able to wake up at 8:15 for an 8:30 lecture."',
          ),
          const SizedBox(height: 28),
          const _ReviewCard(
            avatarAsset: 'https://www.shutterstock.com/image-photo/portrait-beautiful-smiling-teenage-woman-600nw-2709723491.jpg',
            name: 'Layla Mansour',
            tag: 'MEDICINE, YEAR 1',
            review:
                '"Super secure for girls living alone. The building manager is very responsive whenever I had issues."',
          ),
        ],
      ),
    );
  }
}

// ── Single Review Card ─────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final String avatarAsset;
  final String name;
  final String tag;
  final String review;

  const _ReviewCard({
    required this.avatarAsset,
    required this.name,
    required this.tag,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar + name/tag row
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFD0C8B8),
              backgroundImage: avatarAsset.startsWith('http')
                  ? NetworkImage(avatarAsset)
                  : AssetImage(avatarAsset) as ImageProvider,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Review text
        Text(
          review,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
            height: 1.63,
          ),
        ),
      ],
    );
  }
}
