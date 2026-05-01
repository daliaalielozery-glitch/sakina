import 'package:flutter/material.dart';
import 'package:sakina/features/listings/models/listing_model.dart';

class CommunityVoiceWidget extends StatelessWidget {
  final ListingModel listing;
  final Future<void> Function(int rating, String comment)? onSubmitReview;

  const CommunityVoiceWidget({
    super.key,
    required this.listing,
    this.onSubmitReview,
  });

  @override
  Widget build(BuildContext context) {
    final rating = listing.ratingValue;
    final reviewCount = listing.resolvedReviewCount;

    return Container(
      color: const Color(0xFFF0EBE0),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              if (onSubmitReview != null)
                GestureDetector(
                  onTap: () => _openReviewSheet(context),
                  child: const Text(
                    'Write review',
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => _RatingStar(
                    rating: rating,
                    index: index,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                rating > 0 ? rating.toStringAsFixed(1) : 'New',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                reviewCount == 0
                    ? '(No student reviews yet)'
                    : '($reviewCount Student ${reviewCount == 1 ? 'Review' : 'Reviews'})',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7A7060),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (listing.reviews.isEmpty)
            const Text(
              'Reviews will appear here after students rate this listing.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
            )
          else
            ...listing.reviews.expand(
              (review) => [
                _ReviewCard(review: review),
                const SizedBox(height: 28),
              ],
            ),
        ],
      ),
    );
  }

  void _openReviewSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF0EBE0),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _WriteReviewSheet(
        onSubmitReview: onSubmitReview!,
      ),
    );
  }
}

class _RatingStar extends StatelessWidget {
  final double rating;
  final int index;

  const _RatingStar({
    required this.rating,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final value = index + 1;
    final icon = rating >= value
        ? Icons.star_rounded
        : rating >= value - 0.5
            ? Icons.star_half_rounded
            : Icons.star_border_rounded;

    return Icon(
      icon,
      color: const Color(0xFFF5A623),
      size: 26,
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ListingReview review;

  const _ReviewCard({
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = review.reviewerAvatarUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFD0C8B8),
              backgroundImage:
                  avatarUrl == null ? null : NetworkImage(avatarUrl),
              child: avatarUrl == null
                  ? const Icon(Icons.person, color: Color(0xFF7A7060))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.reviewerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    review.tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          review.comment.isNotEmpty
              ? review.comment
              : 'This student left a rating without a written review.',
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

class _WriteReviewSheet extends StatefulWidget {
  final Future<void> Function(int rating, String comment) onSubmitReview;

  const _WriteReviewSheet({
    required this.onSubmitReview,
  });

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D0C0),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Write a Review',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                5,
                (index) {
                  final value = index + 1;
                  return IconButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => setState(() => _rating = value),
                    icon: Icon(
                      _rating >= value
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xFFF5A623),
                      size: 34,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              enabled: !_isSubmitting,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your experience with this listing...',
                filled: true,
                fillColor: const Color(0xFFF8F3EA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFD8D0C0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFD8D0C0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF1A1A1A)),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a star rating.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmitReview(_rating, _commentController.text);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('Review submitted. Thank you!')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
